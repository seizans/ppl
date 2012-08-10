{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Todo where

import Import

getTodoR :: TodoId -> Handler RepJson
getTodoR = undefined

postTodoR :: TodoId -> Handler RepJson
postTodoR = undefined

putTodoR :: TodoId -> Handler RepJson
putTodoR = undefined

deleteTodoR :: TodoId -> Handler RepJson
deleteTodoR = undefined

putTodoTitleR :: TodoId -> Handler RepJson
putTodoTitleR = undefined

putTodoDoneR :: TodoId -> Handler RepJson
putTodoDoneR = undefined

putTodoAsapR :: TodoId -> Handler RepJson
putTodoAsapR = undefined

putTodoDateR :: TodoId -> Handler RepJson
putTodoDateR = undefined

putTodoCreatedR :: TodoId -> Handler RepJson
putTodoCreatedR = undefined

putTodoMemoR :: TodoId -> Handler RepJson
putTodoMemoR = undefined

putTodoProjectR :: TodoId -> Handler RepJson
putTodoProjectR = undefined


