module Handler.PostEdit where

import Import
import Yesod.Form.Bootstrap3
import Yesod.Text.Markdown
import Data.Time.Format
import Database.Persist.Sql

blogPostEditForm :: BlogPost -> AForm Handler BlogPost
blogPostEditForm blogPost = BlogPost 
            <$> areq textField     (bfs ("Title" :: Text)) (Just (blogPostTitle blogPost))
            <*> pure ((parseTimeOrError True defaultTimeLocale "%Y-%m-%d"  "2015-11-21")::UTCTime)
            <*> lift (liftIO getCurrentTime)
            <*> areq markdownField (bfs ("Article" :: Text)) (Just (blogPostArticle blogPost))

getPostEditR :: BlogPostId -> Handler Html
getPostEditR  blogPostId  = do
    blogPost <- runDB $ get404 blogPostId
    (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm $ blogPostEditForm blogPost
    defaultLayout $ do
        $(widgetFile "posts/edit")

-- YesodPersist master => YesodPersistBackend master ~ SqlBackend => …

postPostEditR ::  BlogPostId ->  Handler Html
postPostEditR blogPostId = do
    blogPost <- runDB $ get404 blogPostId
    ((res, widget), enctype)  <- runFormPostNoToken $ renderBootstrap3 BootstrapBasicForm $ blogPostEditForm blogPost
    case res of
      FormSuccess editedBlogPost  -> do
              blogPostDBId <- runDB $ update blogPostId [ BlogPostTitle    =. (blogPostTitle editedBlogPost),
                                                          BlogPostArticle  =. (blogPostArticle editedBlogPost),
                                                          BlogPostEditDate =. (blogPostEditDate editedBlogPost)]
              redirect $ PostDetailsR blogPostId
      FormFailure errorMsgs -> defaultLayout $(widgetFile "errorpage")
      _                     -> defaultLayout $(widgetFile "posts/edit")

