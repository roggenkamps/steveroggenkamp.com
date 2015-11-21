module Handler.Home where

import Import
import Handler.Common
import Database.Persist.Sql

getHomeR :: Handler Html
getHomeR = do
    blogPosts <- runDB $ selectList [] [Desc BlogPostId, LimitTo 3]
    defaultLayout $ do
        $(widgetFile "homepage")
