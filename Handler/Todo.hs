{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Todo where

import Import
import Database.Persist.GenericSql

selectTodo :: Handler [Entity Todo]
selectTodo = runDB $ rawSql "SELECT ?? FROM todo" []


getTodosR :: Handler RepHtml
getTodosR = do
    let widget = do
        setTitle "Todos"
        $(widgetFile "todos")
    defaultLayout widget

getTodoR :: TodoId -> Handler RepHtmlJson
getTodoR todoid = do
    todos <- selectTodo
    let json = object ["hoge".=True]
    let widget = do
        setTitle "Todo"
        $(widgetFile "todo")
    defaultLayoutJson widget json

postTodoR :: TodoId -> Handler ()
postTodoR todoid = do
    -- TODO: check if todoUser == user
    -- TODO: create new record.
    -- TODO: return new ID.
    sendResponse ()

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


