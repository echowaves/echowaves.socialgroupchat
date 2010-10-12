/*
Copyright 2006 Adobe Systems Incorporated
*/

function FABridge(target,bridgeName)
{this.target=target;this.remoteTypeCache={};this.remoteInstanceCache={};this.remoteFunctionCache={};this.localFunctionCache={};this.bridgeID=FABridge.nextBridgeID++;this.name=bridgeName;this.nextLocalFuncID=0;FABridge.instances[this.name]=this;FABridge.idMap[this.bridgeID]=this;return this;}
FABridge.TYPE_ASINSTANCE=1;FABridge.TYPE_ASFUNCTION=2;FABridge.TYPE_JSFUNCTION=3;FABridge.TYPE_ANONYMOUS=4;FABridge.initCallbacks={};FABridge.userTypes={};FABridge.addToUserTypes=function()
{for(var i=0;i<arguments.length;i++)
{FABridge.userTypes[arguments[i]]={'typeName':arguments[i],'enriched':false};}}
FABridge.argsToArray=function(args)
{var result=[];for(var i=0;i<args.length;i++)
{result[i]=args[i];}
return result;}
function instanceFactory(objID)
{this.fb_instance_id=objID;return this;}
function FABridge__invokeJSFunction(args)
{var funcID=args[0];var throughArgs=args.concat();throughArgs.shift();var bridge=FABridge.extractBridgeFromID(funcID);return bridge.invokeLocalFunction(funcID,throughArgs);}
FABridge.addInitializationCallback=function(bridgeName,callback)
{var inst=FABridge.instances[bridgeName];if(inst!=undefined)
{callback.call(inst);return;}
var callbackList=FABridge.initCallbacks[bridgeName];if(callbackList==null)
{FABridge.initCallbacks[bridgeName]=callbackList=[];}
callbackList.push(callback);}
function FABridge__bridgeInitialized(bridgeName){var objects=document.getElementsByTagName("object");var ol=objects.length;var activeObjects=[];if(ol>0){for(var i=0;i<ol;i++){if(typeof objects[i].SetVariable!="undefined"){activeObjects[activeObjects.length]=objects[i];}}}
var embeds=document.getElementsByTagName("embed");var el=embeds.length;var activeEmbeds=[];if(el>0){for(var j=0;j<el;j++){if(typeof embeds[j].SetVariable!="undefined"){activeEmbeds[activeEmbeds.length]=embeds[j];}}}
var aol=activeObjects.length;var ael=activeEmbeds.length;var searchStr="bridgeName="+bridgeName;if((aol==1&&!ael)||(aol==1&&ael==1)){FABridge.attachBridge(activeObjects[0],bridgeName);}
else if(ael==1&&!aol){FABridge.attachBridge(activeEmbeds[0],bridgeName);}
else{var flash_found=false;if(aol>1){for(var k=0;k<aol;k++){var params=activeObjects[k].childNodes;for(var l=0;l<params.length;l++){var param=params[l];if(param.nodeType==1&&param.tagName.toLowerCase()=="param"&&param["name"].toLowerCase()=="flashvars"&&param["value"].indexOf(searchStr)>=0){FABridge.attachBridge(activeObjects[k],bridgeName);flash_found=true;break;}}
if(flash_found){break;}}}
if(!flash_found&&ael>1){for(var m=0;m<ael;m++){var flashVars=activeEmbeds[m].attributes.getNamedItem("flashVars").nodeValue;if(flashVars.indexOf(searchStr)>=0){FABridge.attachBridge(activeEmbeds[m],bridgeName);break;}}}}
return true;}
FABridge.nextBridgeID=0;FABridge.instances={};FABridge.idMap={};FABridge.refCount=0;FABridge.extractBridgeFromID=function(id)
{var bridgeID=(id>>16);return FABridge.idMap[bridgeID];}
FABridge.attachBridge=function(instance,bridgeName)
{var newBridgeInstance=new FABridge(instance,bridgeName);FABridge[bridgeName]=newBridgeInstance;var callbacks=FABridge.initCallbacks[bridgeName];if(callbacks==null)
{return;}
for(var i=0;i<callbacks.length;i++)
{callbacks[i].call(newBridgeInstance);}
delete FABridge.initCallbacks[bridgeName]}
FABridge.blockedMethods={toString:true,get:true,set:true,call:true};FABridge.prototype={root:function()
{return this.deserialize(this.target.getRoot());},releaseASObjects:function()
{return this.target.releaseASObjects();},releaseNamedASObject:function(value)
{if(typeof(value)!="object")
{return false;}
else
{var ret=this.target.releaseNamedASObject(value.fb_instance_id);return ret;}},create:function(className)
{return this.deserialize(this.target.create(className));},makeID:function(token)
{return(this.bridgeID<<16)+token;},getPropertyFromAS:function(objRef,propName)
{if(FABridge.refCount>0)
{throw new Error("You are trying to call recursively into the Flash Player which is not allowed. In most cases the JavaScript setTimeout function, can be used as a workaround.");}
else
{FABridge.refCount++;retVal=this.target.getPropFromAS(objRef,propName);retVal=this.handleError(retVal);FABridge.refCount--;return retVal;}},setPropertyInAS:function(objRef,propName,value)
{if(FABridge.refCount>0)
{throw new Error("You are trying to call recursively into the Flash Player which is not allowed. In most cases the JavaScript setTimeout function, can be used as a workaround.");}
else
{FABridge.refCount++;retVal=this.target.setPropInAS(objRef,propName,this.serialize(value));retVal=this.handleError(retVal);FABridge.refCount--;return retVal;}},callASFunction:function(funcID,args)
{if(FABridge.refCount>0)
{throw new Error("You are trying to call recursively into the Flash Player which is not allowed. In most cases the JavaScript setTimeout function, can be used as a workaround.");}
else
{FABridge.refCount++;retVal=this.target.invokeASFunction(funcID,this.serialize(args));retVal=this.handleError(retVal);FABridge.refCount--;return retVal;}},callASMethod:function(objID,funcName,args)
{if(FABridge.refCount>0)
{throw new Error("You are trying to call recursively into the Flash Player which is not allowed. In most cases the JavaScript setTimeout function, can be used as a workaround.");}
else
{FABridge.refCount++;args=this.serialize(args);retVal=this.target.invokeASMethod(objID,funcName,args);retVal=this.handleError(retVal);FABridge.refCount--;return retVal;}},invokeLocalFunction:function(funcID,args)
{var result;var func=this.localFunctionCache[funcID];if(func!=undefined)
{result=this.serialize(func.apply(null,this.deserialize(args)));}
return result;},getTypeFromName:function(objTypeName)
{return this.remoteTypeCache[objTypeName];},createProxy:function(objID,typeName)
{var objType=this.getTypeFromName(typeName);instanceFactory.prototype=objType;var instance=new instanceFactory(objID);this.remoteInstanceCache[objID]=instance;return instance;},getProxy:function(objID)
{return this.remoteInstanceCache[objID];},addTypeDataToCache:function(typeData)
{var newType=new ASProxy(this,typeData.name);var accessors=typeData.accessors;for(var i=0;i<accessors.length;i++)
{this.addPropertyToType(newType,accessors[i]);}
var methods=typeData.methods;for(var i=0;i<methods.length;i++)
{if(FABridge.blockedMethods[methods[i]]==undefined)
{this.addMethodToType(newType,methods[i]);}}
this.remoteTypeCache[newType.typeName]=newType;return newType;},addPropertyToType:function(ty,propName)
{var c=propName.charAt(0);var setterName;var getterName;if(c>="a"&&c<="z")
{getterName="get"+c.toUpperCase()+propName.substr(1);setterName="set"+c.toUpperCase()+propName.substr(1);}
else
{getterName="get"+propName;setterName="set"+propName;}
ty[setterName]=function(val)
{this.bridge.setPropertyInAS(this.fb_instance_id,propName,val);}
ty[getterName]=function()
{return this.bridge.deserialize(this.bridge.getPropertyFromAS(this.fb_instance_id,propName));}},addMethodToType:function(ty,methodName)
{ty[methodName]=function()
{return this.bridge.deserialize(this.bridge.callASMethod(this.fb_instance_id,methodName,FABridge.argsToArray(arguments)));}},getFunctionProxy:function(funcID)
{var bridge=this;if(this.remoteFunctionCache[funcID]==null)
{this.remoteFunctionCache[funcID]=function()
{bridge.callASFunction(funcID,FABridge.argsToArray(arguments));}}
return this.remoteFunctionCache[funcID];},getFunctionID:function(func)
{if(func.__bridge_id__==undefined)
{func.__bridge_id__=this.makeID(this.nextLocalFuncID++);this.localFunctionCache[func.__bridge_id__]=func;}
return func.__bridge_id__;},serialize:function(value)
{var result={};var t=typeof(value);if(t=="number"||t=="string"||t=="boolean"||t==null||t==undefined)
{result=value;}
else if(value instanceof Array)
{result=[];for(var i=0;i<value.length;i++)
{result[i]=this.serialize(value[i]);}}
else if(t=="function")
{result.type=FABridge.TYPE_JSFUNCTION;result.value=this.getFunctionID(value);}
else if(value instanceof ASProxy)
{result.type=FABridge.TYPE_ASINSTANCE;result.value=value.fb_instance_id;}
else
{result.type=FABridge.TYPE_ANONYMOUS;result.value=value;}
return result;},deserialize:function(packedValue)
{var result;var t=typeof(packedValue);if(t=="number"||t=="string"||t=="boolean"||packedValue==null||packedValue==undefined)
{result=this.handleError(packedValue);}
else if(packedValue instanceof Array)
{result=[];for(var i=0;i<packedValue.length;i++)
{result[i]=this.deserialize(packedValue[i]);}}
else if(t=="object")
{for(var i=0;i<packedValue.newTypes.length;i++)
{this.addTypeDataToCache(packedValue.newTypes[i]);}
for(var aRefID in packedValue.newRefs)
{this.createProxy(aRefID,packedValue.newRefs[aRefID]);}
if(packedValue.type==FABridge.TYPE_PRIMITIVE)
{result=packedValue.value;}
else if(packedValue.type==FABridge.TYPE_ASFUNCTION)
{result=this.getFunctionProxy(packedValue.value);}
else if(packedValue.type==FABridge.TYPE_ASINSTANCE)
{result=this.getProxy(packedValue.value);}
else if(packedValue.type==FABridge.TYPE_ANONYMOUS)
{result=packedValue.value;}}
return result;},addRef:function(obj)
{this.target.incRef(obj.fb_instance_id);},release:function(obj)
{this.target.releaseRef(obj.fb_instance_id);},handleError:function(value)
{if(typeof(value)=="string"&&value.indexOf("__FLASHERROR")==0)
{var myErrorMessage=value.split("||");if(FABridge.refCount>0)
{FABridge.refCount--;}
throw new Error(myErrorMessage[1]);return value;}
else
{return value;}}};ASProxy=function(bridge,typeName)
{this.bridge=bridge;this.typeName=typeName;return this;};ASProxy.prototype={get:function(propName)
{return this.bridge.deserialize(this.bridge.getPropertyFromAS(this.fb_instance_id,propName));},set:function(propName,value)
{this.bridge.setPropertyInAS(this.fb_instance_id,propName,value);},call:function(funcName,args)
{this.bridge.callASMethod(this.fb_instance_id,funcName,args);},addRef:function(){this.bridge.addRef(this);},release:function(){this.bridge.release(this);}};