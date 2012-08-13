{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Tag where

import Import

tagForm :: Maybe Tag -> Form Tag
tagForm mtag = renderDivs $ Tag
    <$> areq textField "Name" (fmap tagName mtag)

getTagsR :: Handler RepHtmlJson
getTagsR = undefined

getTagCreateR :: Handler RepHtml
getTagCreateR = do
    (formWidget, formEnctype) <- generateFormPost (tagForm Nothing)
    let widget = $(widgetFile "tagform")
    defaultLayout widget

postTagCreateR :: Handler RepHtml
postTagCreateR = undefined

getTagR :: TagId -> Handler RepJson
getTagR tagid = undefined

postTagR :: TagId -> Handler RepJson
postTagR tagid = undefined

putTagR :: TagId -> Handler RepJson
putTagR tagid = undefined

deleteTagR :: TagId -> Handler RepJson
deleteTagR tagid = undefined
