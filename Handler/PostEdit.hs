module Handler.PostEdit where

import Import
import Yesod.Form.Bootstrap3
import Yesod.Text.Markdown
import Data.Time.Format
import Handler.Common
import Database.Persist.Sql

blogPostEditForm :: AForm Handler BlogPost
blogPostEditForm = BlogPost 
            <$> areq textField     (bfs ("Title" :: Text)) Nothing -- (Just "A Title")-- (blogPostTitle blogPost))
            <*> pure ((parseTimeOrError True defaultTimeLocale "%Y-%m-%d"  "2015-11-21")::UTCTime)
            <*> lift (liftIO getCurrentTime)
            <*> areq markdownField (bfs ("Article" :: Text)) Nothing -- (Just "An artile") --(blogPostArticle blogPost))

getPostEditR :: BlogPostId -> Handler Html
getPostEditR  blogPostId  = do
    blogPost <- runDB $ get404 blogPostId
    (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm blogPostEditForm
    defaultLayout $ do
        $(widgetFile "posts/edit")

-- YesodPersist master => YesodPersistBackend master ~ SqlBackend => …
{-
postPostEditR ::  BlogPostId ->  Handler Html
postPostEditR blogPostId = do
    blogPost <- runDB $ get404 blogPostId
    ((res, widget), enctype)  <- runFormPostNoToken $ renderBootstrap3 BootstrapBasicForm blogPostEditForm
    case res of
      FormSuccess editedBlogPost  -> do
              blogPostDBId <- runDB $ insert editedBlogPost
              redirect $ PostDetailsR blogPostDBId
      FormFailure errorMsgs -> defaultLayout $(widgetFile "errorpage")
      _                     -> defaultLayout $(widgetFile "posts/edit")
-}
