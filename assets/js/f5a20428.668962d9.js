"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[71730],{48171:e=>{e.exports=JSON.parse('{"functions":[{"name":"observeFirstSelectionWhichIsA","desc":"Observes first selection in the selection list which is of a class\\n\\n```lua\\nRxSelectionUtils.observeFirstSelectionWhichIsA(\\"BasePart\\"):Subscribe(function(part)\\n\\tprint(\\"part\\", part)\\nend)\\n```","params":[{"name":"className","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Observable<Instance?>"}],"function_type":"static","source":{"line":30,"path":"src/selectionutils/src/Shared/RxSelectionUtils.lua"}},{"name":"observeFirstSelectionWhichIsABrio","desc":"Observes first selection in the selection list which is of a class wrapped in a brio\\n\\n```lua\\nRxSelectionUtils.observeFirstSelectionWhichIsA(\\"BasePart\\"):Subscribe(function(brio)\\n\\tif brio:IsDead() then\\n\\t\\treturn\\n\\tend\\n\\n\\tprint(\\"part\\", brio:GetValue())\\nend)\\n```","params":[{"name":"className","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Observable<Brio<Instance>>"}],"function_type":"static","source":{"line":54,"path":"src/selectionutils/src/Shared/RxSelectionUtils.lua"}},{"name":"observeFirstAdornee","desc":"Observes first selection in the selection list which is an \\"Adornee\\"","params":[],"returns":[{"desc":"","lua_type":"Observable<Instance?>"}],"function_type":"static","source":{"line":67,"path":"src/selectionutils/src/Shared/RxSelectionUtils.lua"}},{"name":"observeAdorneesBrio","desc":"Observes selection in which are an \\"Adornee\\"","params":[],"returns":[{"desc":"","lua_type":"Observable<Brio<Instance>>"}],"function_type":"static","source":{"line":78,"path":"src/selectionutils/src/Shared/RxSelectionUtils.lua"}},{"name":"observeFirstSelection","desc":"Observes first selection which meets condition\\n\\n```lua\\nRxSelectionUtils.observeFirstSelection(function(instance)\\n\\treturn instance:IsA(\\"BasePart\\")\\nend):Subscribe(function(part)\\n\\tprint(\\"part\\", part)\\nend)\\n```","params":[{"name":"where","desc":"","lua_type":"callback"}],"returns":[{"desc":"","lua_type":"Observable<Instance?>"}],"function_type":"static","source":{"line":101,"path":"src/selectionutils/src/Shared/RxSelectionUtils.lua"}},{"name":"observeFirstSelectionBrio","desc":"Observes first selection which meets condition","params":[{"name":"where","desc":"","lua_type":"callback"}],"returns":[{"desc":"","lua_type":"Observable<Brio<Instance>>"}],"function_type":"static","source":{"line":140,"path":"src/selectionutils/src/Shared/RxSelectionUtils.lua"}},{"name":"observeSelectionList","desc":"Observes the current selection table.","params":[],"returns":[{"desc":"","lua_type":"Observable<{ Instance }>"}],"function_type":"static","source":{"line":158,"path":"src/selectionutils/src/Shared/RxSelectionUtils.lua"}},{"name":"observeSelectionItemsBrio","desc":"Observes selection items by brio. De-duplicates changed events.","params":[],"returns":[{"desc":"","lua_type":"Observable<Brio<Instance>>"}],"function_type":"static","source":{"line":178,"path":"src/selectionutils/src/Shared/RxSelectionUtils.lua"}}],"properties":[],"types":[],"name":"RxSelectionUtils","desc":"","source":{"line":4,"path":"src/selectionutils/src/Shared/RxSelectionUtils.lua"}}')}}]);