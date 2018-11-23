//
//  ChatViewController.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/21/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift

private typealias NibCellIndentifier = (nibName: String, cellIdentifier: String)
private let kEmptyCellIdentifier = "kEmptyCellIdentifier"

// swiftlint:disable file_length type_body_length
final class ChatViewController: MessageViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var activityIndicator: LoaderView!
    
//    var textView: MessageView?
    
    @IBOutlet weak var activityIndicatorContainer: UIView! {
        didSet {
            let width = activityIndicatorContainer.bounds.width
            let height = activityIndicatorContainer.bounds.height
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            let activityIndicator = LoaderView(frame: frame)
            activityIndicatorContainer.addSubview(activityIndicator)
            self.activityIndicator = activityIndicator
        }
    }
    
    @IBOutlet weak var buttonScrollToBottom: UIButton!
    var buttonScrollToBottomMarginConstraint: NSLayoutConstraint?
    
    var scrollToBottomButtonIsVisible: Bool = false {
        didSet {
            self.buttonScrollToBottom.superview?.layoutIfNeeded()
            
            if self.scrollToBottomButtonIsVisible {
                guard let collectionView = collectionView else {
                    scrollToBottomButtonIsVisible = false
                    return
                }
                
                let collectionViewBottom = collectionView.frame.origin.y + collectionView.frame.height
                self.buttonScrollToBottomMarginConstraint?.constant = (collectionViewBottom - view.frame.height) - 40
            } else {
                self.buttonScrollToBottomMarginConstraint?.constant = 50
            }
            
            if scrollToBottomButtonIsVisible != oldValue {
                UIView.animate(withDuration: 0.5) {
                    self.buttonScrollToBottom.superview?.layoutIfNeeded()
                }
            }
        }
    }
    
    weak var chatTitleView: ChatTitleView?
    weak var chatPreviewModeView: ChatPreviewModeView?
    var documentController: UIDocumentInteractionController?
    
    var replyView: ReplyView!
    var replyString: String = ""
    var messageToEdit: Message?
    var lastTimeSentTypingEvent: Date?
    
    var dataController = ChatDataController()
    
    var searchResult: [(String, Any)] = []
    var searchWord: String = ""
    
    var isRequestingHistory = false
    var isAppendingMessages = false
    
    var subscriptionToken: NotificationToken?
    
    var messagesToken: NotificationToken!
    var messagesQuery: Results<Message>!
    var messages: [Message] = []
    
    var subscription: Subscription? {
        didSet {
            guard let subscription = subscription,
                !subscription.isInvalidated else {
                    return
            }
            
            resetUnreadSeparator()
            
            subscription.setTemporaryMessagesFailed()
            
            subscriptionToken = subscription.observe { [weak self] changes in
                switch changes {
                case .change(let propertyChanges):
                    propertyChanges.forEach {
                        if $0.name == "roomReadObly" || $0.name == "roomMuted" {
                            self?.updateMessageSendingPermission()
                        }
                    }
                default:
                    break
                }
            }
            
            emptySubscriptionState()
            updateSubscriptionInfo()
            markAsRead()
            typingIndicatorView?.dismissIndicator()
            textView.text = DraftMessageManager.draftMessage(for: subscription)
        }
    }
    
    let socketHandlerToken = String.random(5)
    
    //MARK: - View Life Cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        SocketManager.removeConnectionHandler(token: socketHandlerToken)
        messagesToken.invalidate()
        subscriptionToken?.invalidate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    private func setupTitleView() {
        let view = ChatTitleView.instantiateFromNib()
        view?.subscription = subscription
        view?.delegate = self
        navigationItem.titleView = view
        chatTitleView = view
        chatTitleView?.applyTheme()
    }
    
    private func setupScrollToBottomButton() {
        buttonScrollToBottom.layer.cornerRadius = 25
        buttonScrollToBottom.layer.borderWidth = 1
        buttonScrollToBottom.layer.borderColor = view.theme?.bodyText ?? Theme.light.bodyText).cgColor
        buttonScrollToBottom.tintColor = view.theme?.bodyText ?? Theme.light.bodyText
    }
    
    override class func collectionViewLayout(for decoder: NSCoder) -> UICollectionViewLayout {
        return ChatCollectionViewFlowLayout()
    }
    
    private func registerCells() {
        
    }
    
    internal func scrollToBottom(_ animated: Bool = false) {
        let boundsHeight = collectionView?.bounds.size.height ?? 0
        let sizeHeight = collectionView?.contentSize.height ?? 0
        let offset = CGPoint(x: 0, y: max(sizeHeight - boundsHeight, 0))
        collectionView?.setContentOffset(offset, animated: animated)
    }
    
    internal func resetScrollToBottomButtonPosition() {
        scrollToBottomButtonIsVisible = !chatIsLogAtBottom()
    }
    
    func resetUnreadSeparator() {
        dataController.dismissUnreadSeparator = true
        dataController.lastSeen = Date()
    }
    
    //MARK: - Handling Keyboard
    
    internal func emptySubscriptionState() {
        clearListData()
        updateJoinedView()
        
        activityIndicator.startAnimating()
        textView.resignFirstRespoder()
    }
    
    internal func updateSubscriptionInfo() {
        guard let subscription = subscription else { return }
        
        messagesToken?.invalidate()
        
        title = subscription.displayName()
        chatTitleView?.subscription = subscription
        
        if subscription.isValid() {
            updateSubscriptionMessages()
        } else {
            subscription.fetchRoomIdentifier({ [weak self] response in
                self?.subscription = response
            })
        }
        
        updateSubscriptionRoles()
        updateMessageSendingPermission()
    }
    
    //MARK: - Input TextViewController
    
    //MARK: - Message

    private func chatLogIsAtBottom() -> Bool {
        guard let collectionView = collectionView else { return false }

        let height = collectionView.bounds.height
        let bottomInset = collectionView.contentInset.bottom
        let scrollContentSizeHeight = collectionView.contentSize.height
        let verticalOffsetForBottom = scrollContentSizeHeight + bottomInset - height

        return collectionView.contentOffset.y >= (verticalOffsetForBottom - 1)
    }
    
    //MARK: - Subscription
    
    private func markAsRead() {
        guard let subscription = subscription else { return }
        API.current()?.client(SubscriptionsClient.self).markAsRead(subscription: subscription)
    }
    
    //MARK: - IBAction
    
}

//MARK: - UICollectionViewDataSource

extension ChatViewController {
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
}

//MARK: - UIScrollViewDelegate

extension ChatViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    }
}

//MARK: - ChatPreviewModeViewProtocol

extension ChatViewController: ChatPreviewModeViewProtocol {
    
}

//MARK: - Block Message Sending

extension ChatViewController {
    private func updateMessageSendingPermission() {
        guard
            let subscription = subscription,
            let currentUser = AuthManager.currentUser(),
            let username = currentUser.username
            else {
                allowMessageSending()
                return
        }
        
        if subscription.roomReadOnly && subscription.roomOwner != currentUser && !currentUser.hasPermission(.postReadOnly) {
            blockMessageSending(reason: localized("chat.read_only"))
        } else if subscription.roomMuted.contains(username) {
            blockMessageSending(reason: localized("chat.muted"))
        } else {
            allowMessageSending()
        }
    }
    
    private func blockMessageSending(reason: String) {
        textInputbar.textView.placeholder = reason
        textInputbar.backgroundColor = view.theme?.backgroundColor ?? .white
        textInputbar.isUserInteractionEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
    }
    
    private func allowMessageSending() {
        textInputbar.textView.placeholder = ""
        textInputbar.backgroundColor = view.theme?.focusedBackground ?? .backgroundWhite
        textInputbar.isUserInteractionEnabled = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
    }
}

//MARK: - Alerter

extension ChatViewController {
    func alertAPIError(_ error: APIError) {
        switch error {
        case .version(let available, let required):
            let message = String(format: localized("alert.unsupported_feature.message"), available.description, required.description)
            alert(
                title: localized("alert.unsupported_feature.title"),
                message: message
            )
        default:
            break
        }
    }
}

//MARK: - KeyboardFrameViewDelegate

extension ChatViewController: KeyboardFrameViewDelegate {
    
}

extension ChatViewController: SocketConnectionHandler {
    
}

//MARK: - Themeable

extension ChatViewController {
    override func applyTheme() {
        super.applyTheme()
        
    }
}
