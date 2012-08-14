{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Tag where

import Import

tagForm :: Maybe Tag -> Form Tag
tagForm mtag = renderDivs $ Tag
    <$> areq textField "Name" (fmap tagName mtag)

getTagsR :: Handler RepHtml
getTagsR = do
    tagEntities <- runDB $ selectList [] []
    let widget = $(widgetFile "tags")
    defaultLayout widget

getTagCreateR :: Handler RepHtml
getTagCreateR = do
    (formWidget, formEnctype) <- generateFormPost (tagForm Nothing)
    let widget = $(widgetFile "tagform")
    defaultLayout widget

postTagCreateR :: Handler RepHtml
postTagCreateR = do
    ((result, formWidget), formEnctype) <- runFormPost (tagForm Nothing)
    case result of
        FormSuccess res -> do
            _ <- runDB $ insert res
            return ()
        _ -> return ()
    let widget = $(widgetFile "tagform")
    defaultLayout widget

getTagR :: TagId -> Handler RepHtml
getTagR tagid = do
    tag <- runDB $ get404 tagid
    (formWidget, formEnctype) <- generateFormPost (tagForm $ Just tag)
    let widget = $(widgetFile "tagform")
    defaultLayout widget

postTagR :: TagId -> Handler RepHtml
postTagR tagid = do
    ((formResult, formWidget), formEnctype) <- runFormPost (tagForm Nothing)
    case formResult of
        FormSuccess res -> do
            _ <- runDB $ update tagid [TagName =. tagName res]
            return ()
        _ -> return ()
    let widget = $(widgetFile "tagform")
    defaultLayout widget

putTagR :: TagId -> Handler ()
putTagR tagid = do
    param1 <- lookupPostParams "name"
    param2 <- lookupPostParams "location"
    liftIO $ do
        print param1
        print param2
    sendResponse ()

deleteTagR :: TagId -> Handler ()
deleteTagR tagid = do
    ((result, _), _) <- runFormPost (tagForm Nothing)
    case result of
        FormSuccess res -> do
            liftIO $ print res
        _ -> return ()
    sendResponse ()
