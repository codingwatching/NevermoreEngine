"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[45918],{99721:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Constructs a new undo restack entry. See [UndoStack] for usage.","params":[],"returns":[{"desc":"","lua_type":"UndoStackEntry"}],"function_type":"static","source":{"line":22,"path":"src/undostack/src/Shared/UndoStackEntry.lua"}},{"name":"isUndoStackEntry","desc":"Returns true if the etnry is an undo stack entry","params":[{"name":"value","desc":"","lua_type":"any"}],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"static","source":{"line":40,"path":"src/undostack/src/Shared/UndoStackEntry.lua"}},{"name":"SetPromiseUndo","desc":"Sets the handler that will undo the result","params":[{"name":"promiseUndo","desc":"","lua_type":"function | nil"}],"returns":[],"function_type":"method","source":{"line":49,"path":"src/undostack/src/Shared/UndoStackEntry.lua"}},{"name":"SetPromiseRedo","desc":"Sets the handler that will redo the result","params":[{"name":"promiseRedo","desc":"","lua_type":"function | nil"}],"returns":[],"function_type":"method","source":{"line":60,"path":"src/undostack/src/Shared/UndoStackEntry.lua"}},{"name":"HasUndo","desc":"Returns true if this entry can be undone","params":[],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","source":{"line":70,"path":"src/undostack/src/Shared/UndoStackEntry.lua"}},{"name":"HasRedo","desc":"Returns true if this entry can be redone","params":[],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","source":{"line":78,"path":"src/undostack/src/Shared/UndoStackEntry.lua"}},{"name":"PromiseUndo","desc":"Promises undo. Should be done via [UndoStack.PromiseUndo]","params":[{"name":"maid","desc":"","lua_type":"Maid"}],"returns":[{"desc":"","lua_type":"Promise"}],"function_type":"method","source":{"line":88,"path":"src/undostack/src/Shared/UndoStackEntry.lua"}},{"name":"PromiseRedo","desc":"Promises redo execution. Should be done via [UndoStack.PromiseRedo]","params":[{"name":"maid","desc":"","lua_type":"Maid"}],"returns":[{"desc":"","lua_type":"Promise"}],"function_type":"method","source":{"line":109,"path":"src/undostack/src/Shared/UndoStackEntry.lua"}}],"properties":[],"types":[],"name":"UndoStackEntry","desc":"Holds undo state","source":{"line":5,"path":"src/undostack/src/Shared/UndoStackEntry.lua"}}')}}]);