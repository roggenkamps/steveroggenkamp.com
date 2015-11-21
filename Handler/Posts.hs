module Handler.Posts where

import Import
import Handler.Common
import Database.Persist.Sql

getPostsR :: Handler Html
getPostsR = do
    blogPosts <- runDB $ selectList [] [Desc BlogPostId]
    defaultLayout $ do
        $(widgetFile "posts/index")
