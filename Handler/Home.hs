module Handler.Home where

import Import

getHomeR :: Handler Html
getHomeR = do
    blogPosts <- runDB $ selectList [] [Desc BlogPostId, LimitTo 3]
    defaultLayout $ do
        $(widgetFile "homepage")
