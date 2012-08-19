{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Todo where

import Import
import Database.Persist.GenericSql
import Data.Time (getCurrentTime)

--selectTodo :: Handler [(Entity Todo, Entity Project, [Entity Tag])]
selectTodo :: Handler [(Entity Todo, Entity Project, Entity Tag, Entity User)]
selectTodo = runDB $ rawSql "SELECT ??, ??, ??, ?? FROM todo, project, tag_todo, tag, user WHERE todo.project = project.id AND todo.id = tag_todo.todo AND tag_todo.tag = tag.id AND todo.user = user.id" []


getTodosR :: Handler RepHtml
getTodosR = do
    authId <- requireAuthId
    entityTuples <- selectTodo
    let todoListWidget = $(widgetFile "todolist")
    defaultLayout todoListWidget

getTodoCreateR :: Handler RepHtml
getTodoCreateR = do
    authId <- requireAuthId
    time <- liftIO getCurrentTime
--    (projects, tags) <- runDB $ do
--        ps <- selectList [] []
--        ts <- selectList [] []
--        return ps ts
    projects <- runDB $ selectList [] []
    tags <- runDB $ selectList [] []
    (formWidget, formEnctype) <- generateFormPost $ todoForm authId time projects tags
    defaultLayout $ $(widgetFile "form")

todoForm :: UserId -> UTCTime -> [Entity Project] -> [Entity Tag] -> Form TodoForm
todoForm authId time projects tags = renderBootstrap $ TodoForm
    <$> areq textField "Title" Nothing
    <*> areq intField "Point" Nothing
    <*> areq boolField "Done" Nothing
    <*> areq boolField "Asap" Nothing
    <*> pure time
    <*> pure time
    <*> areq textField "Memo" Nothing
    <*> areq hiddenField "" (Just authId)
    <*> areq (selectFieldList projectFields) "Project" Nothing
    <*> areq (multiSelectFieldList tagFields) "Tags" Nothing
  where
    projectFields = map (\p -> (projectName $ entityVal p, entityKey p)) projects
    tagFields = map (\t -> (tagName $ entityVal t, entityKey t)) tags

data TodoForm = TodoForm
    { todoFormTitle :: Text
    , todoFormPoint :: Int
    , todoFormDone  :: Bool
    , todoFormAsap  :: Bool
    , todoFormDate  :: UTCTime
    , todoFormCreated :: UTCTime
    , todoFormMemo  :: Text
    , todoFormUser  :: UserId
    , todoFormProject :: ProjectId
    , todoFormTags  :: [TagId]
    }
  deriving Show

postTodoCreateR :: Handler RepHtml
postTodoCreateR = do
    authId <- requireAuthId
    time <- liftIO getCurrentTime
    projects <- runDB $ selectList [] []
    tags <- runDB $ selectList [] []
    ((formResult, formWidget), formEnctype) <- runFormPost $ todoForm authId time projects tags
    case formResult of
        FormMissing -> defaultLayout $ $(widgetFile "form")
        FormFailure _ts -> defaultLayout $ $(widgetFile "form")
        FormSuccess res -> do
            let todoEntity = Todo
                    { todoTitle = todoFormTitle res
                    , todoPoint = todoFormPoint res
                    , todoDone  = todoFormDone  res
                    , todoAsap  = todoFormAsap  res
                    , todoDate  = todoFormDate  res
                    , todoCreated = todoFormCreated res
                    , todoMemo  = todoFormMemo  res
                    , todoUser  = todoFormUser  res
                    , todoProject = todoFormProject res
                    }
            runDB $ do
                todoId <- insert todoEntity
                let tagTodoEntities = map (\tagId -> TagTodo { tagTodoTag = tagId, tagTodoTodo = todoId}) (todoFormTags res)
                mapM_ insert tagTodoEntities
            defaultLayout $ $(widgetFile "form") -- TODO: updateへのリダイレクト
    -- TODO: check if todoUser == user
    -- TODO: create new record.
    -- TODO: return new ID.


getTodoR :: TodoId -> Handler RepJson
getTodoR todoid = undefined
postTodoR :: TodoId -> Handler RepJson
postTodoR todoid = undefined
putTodoR :: TodoId -> Handler RepJson
putTodoR todoid = undefined

deleteTodoR :: TodoId -> Handler RepJson
deleteTodoR todoid = undefined

putTodoTitleR :: TodoId -> Handler RepJson
putTodoTitleR todoid = undefined

putTodoDoneR :: TodoId -> Handler RepJson
putTodoDoneR todoid = undefined

putTodoAsapR :: TodoId -> Handler RepJson
putTodoAsapR todoid = undefined

putTodoDateR :: TodoId -> Handler RepJson
putTodoDateR todoid = undefined

putTodoCreatedR :: TodoId -> Handler RepJson
putTodoCreatedR todoid = undefined

putTodoMemoR :: TodoId -> Handler RepJson
putTodoMemoR todoid = undefined

putTodoProjectR :: TodoId -> Handler RepJson
putTodoProjectR todoid = undefined


