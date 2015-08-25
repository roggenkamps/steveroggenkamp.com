module Handler.PostNew where

import Import
import Yesod.Form.Bootstrap3
import Yesod.Text.Markdown

blogPostEditForm :: AForm Handler BlogPost
blogPostEditForm = BlogPost 
            <$> areq textField     (bfs ("Title" :: Text)) Nothing
            <*> lift (liftIO getCurrentTime)
            <*> lift (liftIO getCurrentTime)
            <*> areq markdownField (bfs ("Article" :: Text)) Nothing

getPostNewR :: Handler Html
getPostNewR = do
    (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm blogPostEditForm
    defaultLayout $ do
        $(widgetFile "posts/new")

-- YesodPersist master => YesodPersistBackend master ~ SqlBackend => …

postPostNewR :: Handler Html
postPostNewR = do
    ((res, widget), enctype)  <- runFormPost $ renderBootstrap3 BootstrapBasicForm blogPostEditForm
    case res of
      FormSuccess blogPost -> do
              blogPostId <- runDB $ insert blogPost
              redirect $ PostDetailsR blogPostId
      _ -> defaultLayout $(widgetFile "posts/new")
