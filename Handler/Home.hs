module Handler.Home where

import Import

getHomeR :: Handler Html
getHomeR = do
    blogPosts <- runDB $ selectList [] [LimitTo 3]
    defaultLayout $ do
        $(widgetFile "homepage")

{-
   where
    selectArticles :: Text -> Handler [Entity BlogPost]
    selectArticles t = runDB $ rawSql s [toPersistValue t]
      where s = "SELECT ?? FROM blog_post where id = t"
-}
