module Handler.PostNew where

import Import
import Yesod.Form.Bootstrap3
import Yesod.Text.Markdown

blogPostNewForm :: AForm Handler BlogPost
blogPostNewForm = BlogPost 
            <$> areq textField     (bfs ("Title" :: Text)) Nothing
            <*> lift (liftIO getCurrentTime)
            <*> lift (liftIO getCurrentTime)
            <*> areq markdownField (bfs ("Article" :: Text)) Nothing

getPostNewR :: Handler Html
getPostNewR = do
    (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm blogPostNewForm
    defaultLayout $ do
        $(widgetFile "posts/new")

-- YesodPersist master => YesodPersistBackend master ~ SqlBackend => …

postPostNewR :: Handler Html
postPostNewR = do
    ((res, widget), enctype)  <- runFormPostNoToken $ renderBootstrap3 BootstrapBasicForm blogPostNewForm
    case res of
      FormSuccess blogPost -> do
              blogPostId <- runDB $ insert blogPost
              redirect $ PostDetailsR blogPostId
      FormFailure errorMsgs -> defaultLayout $(widgetFile "errorpage")
      _                    -> defaultLayout $(widgetFile "posts/new")
