{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Project where

import Import
import Yesod.Form.Jquery
import Data.Time.Clock
import qualified Data.Text as T

projectForm :: Maybe Project -> UTCTime -> Form Project
projectForm mproject time = 
    renderDivs $ Project
    <$> areq projectNameField "Name" (projectName <$> mproject)
    <*> pure time
  where
    errorMessage :: Text
    errorMessage = "The length of ProjectName should be >= 3."
    projectNameField = checkBool (\t -> T.length t >= 3) errorMessage textField

getProjectsR :: Handler RepHtml
getProjectsR = do
    time <- liftIO getCurrentTime
    projectEntities <- runDB $ selectList ([] :: [Filter Project]) []
    (formWidget, formEnctype) <- generateFormPost $ projectForm Nothing time
    let listWidget = $(widgetFile "projectlist")
    let widget = $(widgetFile "projectportal")
    defaultLayout widget

getProjectCreateR :: Handler RepHtml
getProjectCreateR = do
    time <- liftIO getCurrentTime
    (formWidget, formEnctype) <- generateFormPost $ projectForm Nothing time
    let widget = $(widgetFile "projectform")
    defaultLayout widget

postProjectCreateR :: Handler RepHtml
postProjectCreateR = do
    time <- liftIO getCurrentTime
    ((formResult, formWidget), formEnctype) <- runFormPost $ projectForm Nothing time
    case formResult of
        FormMissing -> do
            liftIO $ print formResult
            notFound
        FormFailure texts -> do
            liftIO $ print formResult
            defaultLayout $ $(widgetFile "projectform")
        FormSuccess res -> do
            key <- runDB $ insert res
            liftIO $ print (show key)
            redirect $ ProjectR key

getProjectR :: ProjectId -> Handler RepHtmlJson
getProjectR projectid = do
    projectEntity <- runDB $ get404 projectid
    time <- liftIO getCurrentTime
    (formWidget, formEnctype) <- generateFormPost $ projectForm (Just projectEntity) time
    let widget = $(widgetFile "projectform")
    defaultLayoutJson widget projectEntity

putProjectR :: ProjectId -> Handler RepJson
putProjectR projectid = do
    time <- liftIO getCurrentTime
    ((formResult, formWidget), formEnctype) <- runFormPost $ projectForm Nothing time
    case formResult of
        FormMissing -> notFound
        FormFailure texts -> notFound
        FormSuccess project -> do
            runDB $ update projectid [ProjectName =. projectName project, ProjectCreated =. projectCreated project]
            jsonToRepJson project

deleteProjectR :: ProjectId -> Handler RepHtmlJson
deleteProjectR projectid = do
    runDB $ do
        _ <- get404 projectid --- check if the record exists.
        delete projectid
    redirect ProjectsR
