{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Tag where

import Import

getTagsR :: Handler RepHtmlJson
getTagsR = undefined

getTagCreateR :: Handler RepHtml
getTagCreateR = undefined

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
