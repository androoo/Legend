//
//  ChatViewController.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/21/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

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
        
        SocketManager.addConnectionHandler(token: socketHandlerToken, handler: nil)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.isPrefetchingEnabled = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.showsHorizontalScrollIndicator = false
        enableInteractiveKeyboardDismissal()
        
//        self.collectionView.isInverted = false
//        self.collectionView.bounces = true
//        self.collectionView.shakeToClearEnabled = true
//        isKeyboardPanningEnabled = true
//        shouldScrollToBottomAfterKeyboardShows = false
        
        messageView.leftButton.setImage(UIImage(named: "Upload"), for: .normal)
            
        setupTitleView()
        setupTextViewSettings()
        setupScrollToBottomButton()
        setupMessageInputView()
        
        // Remove title from back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        view.bringSubview(toFront: activityIndicatorContainer)
        view.bringSubview(toFront: buttonScrollToBottom)
        view.bringSubview(toFront: messageView.textView)
        
        if buttonScrollToBottomMarginConstraint == nil {
            buttonScrollToBottomMarginConstraint = buttonScrollToBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50)
            buttonScrollToBottomMarginConstraint?.isActive = true
            
            setupReplyView()
            ThemeManager.addObserver(self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        ThemeManager.addObserver(navigationController?.navigationBar)
        messageView.inputView?.applyTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenname = String(describing: ChatViewController.self)
        //Log analytics
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateChatPreviewModeViewConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion:  { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    private func setupTextViewSettings() {
//        messageView.textView.register
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
    
    // keyboardHeightConstraint is the same as keyboardHC
    weak var keyboardHeightConstraint: NSLayoutConstraint?
    weak var textInputBackgroundHeightConstaint: NSLayoutConstraint?
    
    var keyboardFrame: KeyboardFrameView?
    let textInputbarBackground = UIToolbar()
    var oldTextInputbarBgIsTransparent = false
    
    private func enableInteractiveKeyboardDismissal() {
        keyboardFrame = KeyboardFrameView(withDelegate: self)
    }
    
    private func updateKeyboardConstraints(frame: CGRect) {
        if keyboardHeightConstraint == nil {
            keyboardHeightConstraint = self.view.constraints.first {
                ($0.firstItem as? UIView) == self.view &&
                    ($0.secondItem as? MessageTextView) == self.messageView
            }
        }
        
        // Adding textInputBar background so that the app can support devices with safe area insets.
        // The tool bar (textInputBar) background sometimes dissapears on keyboard slide outs,
        // with no real fix for it provided by Apple in UIKit.
        updateTextInputbarBackground()
        
        var keyboardHeight = frame.height
        
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardHeight > view.safeAreaInsets.bottom ? keyboardHeight : view.safeAreaInsets.bottom
        }
        
        keyboardHeightConstraint?.constant = keyboardHeight
    }
    
    private func updateTextInputbarBackground() {
        if #available(iOS 11.0, *) {
            if !messageView.subviews.contains(textInputbarBackground) {
                insertTextInputbarBackground()
            }
        }
    }
    
    private func insertTextInputbarBackground() {
        messageView.insertSubview(textInputbarBackground, at: 0)
        textInputbarBackground.translatesAutoresizingMaskIntoConstraints = false
        
        textInputbarBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        textInputbarBackground.widthAnchor.constraint(equalTo: messageView.widthAnchor).isActive = true
        textInputbarBackground.topAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
        textInputbarBackground.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true
    }
    
    private func setupMessageInputView() {
        borderColor = .lightGray
        messageView.textViewInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 16)
        messageView.setButton(title: "Add", for: .normal, position: .left)
        messageView.addButton(target: self, action: #selector(onLeftButton), position: .left)
        messageView.leftButtonTint = .blue
        messageView.showLeftButton = true
        
        messageView.setButton(inset: 10, position: .left)
        
        messageView.textView.placeholderText = "New message..."
        messageView.textView.placeholderTextColor = .lightGray
    }
    
    @objc func onLeftButton() {
        print("Did press left button")
    }
    
    internal func emptySubscriptionState() {
        clearListData()
        updateJoinedView()
        
        activityIndicator.startAnimating()
        textView.resignFirstRespoder()
    }
    
    //MARK: - Input TextViewController
    
    //MARK: - Message
    func sendCommand(command: String, params: String) {
        guard let subscription = subscription else { return }
        let client = API.current()?.client(CommandsClient.self)
        client?.runCommand(command: command, params: params, roomId: subscription.rid, errored: alertAPIError)
    }
    
    private func sendTextMessage(text: String) {
        guard let subscription = subscription, text.count > 0 else {
                return
        }
        
        guard let client = API.current()?.client(MessagesClient.self) else { return Alert.defaultError.present() }
        
        client.sendMessage(text: text, subscription: subscription)
    }
    
    private func editTextMessage(message: Message, text: String) {
        guard let client = API.current()?.client(MessagesClient.self) else { return Alert.defaultError.present() }
        client.updateMessage(message, text: text)
    }
    
    private func updateCellForMessage(identifier: String) {
        guard let indexPath = self.dataController.indexPathOfMessage(identifier: identifier) else { return }
        
        UIView.performWithoutAnimation {
            collectionView?.reloadItems(at: [indexPath])
        }
    }

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
    
    internal func subscribe(for subscription: Subscription) {
        MessageManager.changes(subscription)
        MessageManager.subscribeDeleteMessage(subscription) { [weak self] msgId in
            self?.deleteMessage(msgId: msgId)
        }
        registerTypingEvent(subscription)
    }
    
    internal func unsubscribe(for subscription: Subscription) {
        SocketManager.unsubscribe(eventName: subscription.rid)
        SocketManager.unsubscribe(eventName: "\(subscription.rid)/typing")
        SocketManager.unsubscribe(eventName: "\(subscription.rid)/deleteMessage")
    }
    
    internal func emptySubscriptionState() {
        clearListData()
        updateJoinedView()
        
        activityIndicator?.startAnimating()
        textView.resignFirstResponder()
    }
    
    internal func updateJoinedView() {
        guard let subscription = subscription else { return }
        
        if subscription.isJoined() {
            setTextInputbarHidden(false, animated: false)
            chatPreviewModeView?.removeFromSuperview()
        } else {
            setTextInputbarHidden(true, animated: false)
            showChatPreviewModeView()
        }
    }
    
    internal func clearListData() {
        collectionView?.performBatchUpdates({
            let indexPaths = self.dataController.clear()
            self.collectionView?.deleteItems(at: indexPaths)
        }, completion: { _ in
            CATransaction.commit()
        })
    }
    
    internal func deleteMessage(msgId: String) {
        guard let collectionView = collectionView else { return }
        dataController.delete(msgId: msgId)
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        })
        Realm.execute({ _ in
            Message.delete(withIdentifier: msgId)
        })
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
    
    internal func updateSubscriptionMessages() {
        guard let subscription = subscription else { return }
        
        messagesQuery = subscription.fetchMessagesQueryResults()
        
        dataController.loadedAllMessages = false
        isRequestingHistory = false
        
        updateMessagesQueryNotificationBlock()
        loadMoreMessagesFrom(date: nil)
        subscribe(for: subscription)
    }
    
    func registerTypingEvent(_ subscription: Subscription) {
        typingIndicatorView?.interval = 0
        guard let user = AuthManager.currentUser() else { return Log.debug("Could not register TypingEvent") }
        
        SubscriptionManager.subscribeTypingEvent(subscription) { [weak self] username, flag in
            guard let username = username, username != user.username else { return }
            
            let isAtBottom = self?.chatLogIsAtBottom()
            
            if flag {
                self?.typingIndicatorView?.insertUsername(username)
            } else {
                self?.typingIndicatorView?.removeUsername(username)
            }
            
            if let isAtBottom = isAtBottom,
                isAtBottom == true {
                self?.scrollToBottom(true)
            }
        }
    }
    
    private func updateMessagesQueryNotificationBlock() {
        messagesToken?.invalidate()
        messagesToken = messagesQuery.observe { [unowned self] changes in
            guard case .update(_, _, let insertions, let modifications) = changes else {
                return
            }
            
            if insertions.count > 0 {
                var newMessages: [Message] = []
                for insertion in insertions {
                    guard insertion < self.messagesQuery.count else { continue }
                    let newMessage = Message(value: self.messagesQuery[insertion])
                    newMessages.append(newMessage)
                }
                
                self.messages.append(contentsOf: newMessages)
                
                self.appendMessages(messages: newMessages, completion: {
                    self.markAsRead()
                })
            }
            
            if modifications.count > 0 {
                let isAtBottom = self.chatLogIsAtBottom()
                
                var indexPathModifications: [Int] = []
                
                for modified in modifications {
                    guard modified < self.messagesQuery.count else { continue }
                    
                    let message = Message(value: self.messagesQuery[modified])
                    let index = self.dataController.update(message)
                    
                    if index >= 0 && !indexPathModifications.contains(index) {
                        indexPathModifications.append(index)
                    }
                }
                
                if indexPathModifications.count > 0 {
                    UIView.performWithoutAnimation {
                        self.collectionView?.performBatchUpdates({
                            self.collectionView?.reloadItems(at: indexPathModifications.map { IndexPath(row: $0, section: 0) })
                        }, completion: { _ in
                            if isAtBottom {
                                self.scrollToBottom()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func syncCollectionView() {
        collectionView?.performBatchUpdates({
            let (indexPaths, removedIndexPaths) = dataController.insert([])
            collectionView?.insertItems(at: indexPaths)
            collectionView?.deleteItems(at: removedIndexPaths)
        }, completion: nil)
    }
    
    func loadHistoryFromRemote(date: Date?, loadNextPage: Bool = true) {
        guard let subscription = subscription else { return }
        
        let tempSubscription = Subscription(value: subscription)
        
        MessageManager.getHistory(tempSubscription, lastMessageDate: date) { [weak self] nextPageDate in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if loadNextPage {
                    self?.isRequestingHistory = false
                    self?.loadMoreMessagesFrom(date: date, loadRemoteHistory: false)
                }
                
                if nextPageDate == nil {
                    self?.dataController.loadedAllMessages = true
                    self?.syncCollectionView()
                } else {
                    self?.dataController.loadedAllMessages = false
                }
                
                if let nextPageDate = nextPageDate, loadNextPage {
                    self?.loadHistoryFromRemote(date: nextPageDate, loadNextPage: false)
                }
            }
        }
    }
    
    private func loadMoreMessagesFrom(date: Date?, loadRemoteHistory: Bool = true) {
        guard let subscription = subscription else { return }
        
        isRequestingHistory = true
        
        let newMessages = subscription.fetchMessages(lastMessageDate: date).map({ Message(value: $0) })
        if newMessages.count > 0 {
            messages.append(contentsOf: newMessages)
            appendMessages(messages: newMessages, completion: { [weak self] in
                self?.activityIndicator.stopAnimating()
                
                if date == nil {
                    self?.collectionView?.reloadData()
                }
                
                if SocketManager.isConnected() {
                    if !loadRemoteHistory {
                        self?.isRequestingHistory = false
                    } else {
                        self?.loadHistoryFromRemote(date: date)
                    }
                } else {
                    self?.isRequestingHistory = false
                }
            })
        } else {
            if date == nil {
                collectionView?.reloadData()
            }
            
            if SocketManager.isConnected() {
                if loadRemoteHistory {
                    loadHistoryFromRemote(date: date)
                } else {
                    isRequestingHistory = false
                }
            } else {
                isRequestingHistory = false
            }
        }
    }
    
    private func appendMessages(messages: [Message], completion: VoidCompletion?) {
        guard let subscription = subscription, let collectionView = collectionView, !subscription.isInvalidated else {
            return
        }
        
        guard !isAppendingMessages else {
            Log.debug("[APPEND MESSAGES] Blocked trying to append \(messages.count) messages")
            // This message can be called many times during the app execution and we need
            // to call them one per time, to avoid adding the same message multiple times
            // to the list. Also, we keep the subscription identifier in order to make sure
            // we're updating the same subscription, because this view controller is reused
            // for all the chats.
            let oldSubscriptionIdentifier = subscription.identifier
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
                guard oldSubscriptionIdentifier == self?.subscription?.identifier else { return }
                self?.appendMessages(messages: messages, completion: completion)
            })
            
            return
        }
        
        isAppendingMessages = true
        
        var tempMessages: [Message] = []
        for message in messages {
            tempMessages.append(Message(value: message))
        }
        
        DispatchQueue.global(qos: .background).async {
            var objs: [ChatData] = []
            var newMessages: [Message] = []
            
            // Do not add duplicated messages
            for message in tempMessages {
                var insert = true
                
                for obj in self.dataController.data where message.identifier == obj.message?.identifier {
                    insert = false
                }
                
                if insert {
                    newMessages.append(message)
                }
            }
            
            // Normalize data into ChatData object
            for message in newMessages {
                guard let createdAt = message.createdAt else { continue }
                var obj = ChatData(type: .message, timestamp: createdAt)
                obj.message = message
                objs.append(obj)
            }
            
            // No new data? Don't update it then
            if objs.count == 0 {
                if self.dataController.dismissUnreadSeparator {
                    DispatchQueue.main.async {
                        self.syncCollectionView()
                    }
                }
                
                DispatchQueue.main.async {
                    self.isAppendingMessages = false
                    completion?()
                }
                
                return
            }
            
            DispatchQueue.main.async {
                collectionView.performBatchUpdates({
                    let (indexPaths, removedIndexPaths) = self.dataController.insert(objs)
                    collectionView.insertItems(at: indexPaths)
                    collectionView.deleteItems(at: removedIndexPaths)
                }, completion: { _ in
                    self.isAppendingMessages = false
                    completion?()
                })
            }
        }
    }
    
    private func showChatPreviewModeView() {
        chatPreviewModeView?.removeFromSuperview()
        
        if let previewView = ChatPreviewModeView.instantiateFromNib() {
            previewView.delegate = self
            previewView.subscription = subscription
            previewView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(previewView)
            
            NSLayoutConstraint.activate([
                previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
            
            collectionView?.bottomAnchor.constraint(equalTo: previewView.topAnchor).isActive = true
            
            chatPreviewModeView = previewView
            updateChatPreviewModeViewConstraints()
            
            previewView.applyTheme()
        }
    }
    
    private func updateChatPreviewModeViewConstraints() {
        if #available(iOS 11.0, *) {
            chatPreviewModeView?.bottomInset = view.safeAreaInsets.bottom
        }
    }
    
    private func isContentBiggerThanContainerHeight() -> Bool {
        if let contentHeight = self.collectionView?.contentSize.height {
            if let collectionViewHeight = self.collectionView?.frame.height {
                if contentHeight < collectionViewHeight {
                    return false
                }
            }
        }
        
        return true
    }
    
    //MARK: - IBAction
    
    @IBAction func showSearchMessages() {
        guard let storyboard = storyboard,
            let messageList = storyboard.instantiateViewController(withIdentifier: "MessagesListViewController") as? MessagesListViewController else {
                return
        }
        messageList.data.subscription = subscription
        messageList.data.isSearchMessages = true
        let searchMessagesNav = BaseNavigationController(rootViewController: messageList)
        present(searchMessagesNav, animated: true, completion: nil)
    }
    
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
