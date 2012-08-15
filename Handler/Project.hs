{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Project where

import Import
import Yesod.Form.Jquery


projectForm :: Maybe Project -> Form Project
projectForm mproject = renderDivs $ Project
    <$> areq textField "Name" (fmap projectName mproject)
    <*> areq (jqueryDayField def { jdsChangeYear = True, jdsYearRange = "2000:+5"}) "CREATED" (fmap projectCreated mproject)

getProjectsR :: Handler RepHtml
getProjectsR = do
    projectEntities <- runDB $ selectList ([] :: [Filter Project]) []
    (formWidget, formEnctype) <- generateFormPost $ projectForm Nothing
    let listWidget = $(widgetFile "projectlist")
    let widget = $(widgetFile "projectportal")
    defaultLayout widget

getProjectCreateR :: Handler RepHtml
getProjectCreateR = do
    (formWidget, formEnctype) <- generateFormPost $ projectForm Nothing
    let widget = $(widgetFile "projectform")
    defaultLayout widget

postProjectCreateR :: Handler RepHtml
postProjectCreateR = do
    ((formResult, formWidget), formEnctype) <- runFormPost $ projectForm Nothing
    case formResult of
        FormSuccess res -> do
            _ <- runDB $ insert res
            return ()
        _ -> return ()
    let widget = $(widgetFile "projectform")
    defaultLayout widget

getProjectR :: ProjectId -> Handler RepHtmlJson
getProjectR projectid = undefined

putProjectR :: ProjectId -> Handler RepHtmlJson
putProjectR projectid = undefined

deleteProjectR :: ProjectId -> Handler RepHtmlJson
deleteProjectR projectid = undefined
