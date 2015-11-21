module Handler.PostDetails where

import Import
import Handler.Common
import Database.Persist.Sql

getPostDetailsR :: BlogPostId -> Handler Html
getPostDetailsR blogPostId = do
    blogPost <- runDB $ get404 blogPostId
    defaultLayout $ do
        $(widgetFile "postDetails/post")
