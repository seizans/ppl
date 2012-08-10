{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Todo where

import Import

getTodoR :: TodoId -> Handler RepHtmlJson
getTodoR todoid = do
    let json = object []
    let widget = do
        setTitle "Todo"
        $(widgetFile "todo")
    defaultLayoutJson widget json

postTodoR :: TodoId -> Handler RepJson
postTodoR todoid = do
    let
--    when (todoid /= 0) $ return ()

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


