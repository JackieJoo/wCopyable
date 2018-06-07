( function _Copyable_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );/*hhh*/
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _global = _global_; var _ = _global_.wTools;

  _.include( 'wProto' );
  _.include( 'wCloner' );
  _.include( 'wStringer' );

}

//

var _global = _global_; var _ = _global_.wTools;
var _hasOwnProperty = Object.hasOwnProperty;

//

/**
 * Mixin this into prototype of another object.
 * @param {object} cls - constructor of class to mixin.
 * @method _mixin
 * @memberof wCopyable#
 */

function _mixin( cls )
{

  var dstProto = cls.prototype;
  var has =
  {
    Composes : 'Composes',
    constructor : 'constructor',
  }

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( cls ),'mixin expects constructor, but got',_.strPrimitiveTypeOf( cls ) );
  _.assertMapOwnAll( dstProto,has );
  _.assert( _hasOwnProperty.call( dstProto,'constructor' ),'prototype of object should has own constructor' );

  /* */

  _.mixinApply
  ({
    dstProto : dstProto,
    descriptor : Self,
  });

  /* instance accessors */

  var readOnly = { readOnlyProduct : 0 };
  var names =
  {
    Self : readOnly,
    Parent : readOnly,
    className : readOnly,

    copyableFields : readOnly,
    loggableFields : readOnly,
    allFields : readOnly,

    nickName : readOnly,
    uniqueName : readOnly,
  }

  _.accessorReadOnly
  ({
    object : dstProto,
    names : names,
    preserveValues : 0,
    strict : 0,
    prime : 0,
    enumerable : 0,
  });

  /* static accessors */

  var names =
  {
    Self : readOnly,
    Parent : readOnly,
    className : readOnly,
    copyableFields : readOnly,
    loggableFields : readOnly,
    allFields : readOnly,
  }

  _.accessorReadOnly
  ({
    object : cls,
    names : names,
    preserveValues : 0,
    strict : 0,
    prime : 0,
    enumerable : 0,
  });

  /* */

  // var names =
  // {
  //   Type : 'Type',
  //   type : 'type',
  //   fields : 'fields',
  // }
  //
  // _.accessorForbid
  // ({
  //   object : dstProto,
  //   names : names,
  //   preserveValues : 0,
  //   strict : 0,
  // });

  /* */

  if( Config.debug )
  {

    if( _.routineIs( dstProto._equalAre ) )
    _.assert( dstProto._equalAre.length === 3 || dstProto._equalAre.length === 0 );

    if( _.routineIs( dstProto.equalWith ) )
    _.assert( dstProto.equalWith.length <= 2 );

    _.assert( dstProto._allFieldsGet === _allFieldsGet );
    _.assert( dstProto._copyableFieldsGet === _copyableFieldsGet );
    _.assert( dstProto._loggableFieldsGet === _loggableFieldsGet );

    _.assert( dstProto.constructor._allFieldsGet === _allFieldsStaticGet );
    _.assert( dstProto.constructor._copyableFieldsGet === _copyableFieldsStaticGet );
    _.assert( dstProto.constructor._loggableFieldsGet === _loggableFieldsStaticGet );

    _.assert( dstProto.finit.name !== 'finitEventHandler', 'wEventHandler mixin should goes after wCopyable mixin.' );
    _.assert( !_.mixinHas( dstProto,'wEventHandler' ), 'wEventHandler mixin should goes after wCopyable mixin.' );


  }

}

//

/**
 * Default instance constructor.
 * @method init
 * @memberof wCopyable#
 */

function init( o )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

}

//

/**
 * Instance descturctor.
 * @method finit
 * @memberof wCopyable#
 */

function finit()
{
  var self = this;
  _.instanceFinit( self );
}

//

/**
 * Is this instance finited.
 * @method finitedIs
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

function finitedIs()
{
  var self = this;
  return _.instanceIsFinited( self );
}

//

/**
 * Extend by data from another instance.
 * @param {object} src - another isntance.
 * @method extend
 * @memberof wCopyable#
 */

function extend( src )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( src instanceof self.Self || _.mapIs( src ) );

  for( var s in src )
  {
    if( _.objectIs( self[ s ] ) )
    {
      if( _.routineIs( self[ s ].extend ) )
      self[ s ].extend( src[ s ] );
      else
      _.mapExtend( self[ s ],src[ s ] );
    }
    else
    {
      self[ s ] = src[ s ];
    }
  }

  return self;
}

//

/**
 * Copy data from another instance.
 * @param {object} src - another isntance.
 * @method copy
 * @memberof wCopyable#
 */

function copy( src )
{
  var self = this;
  var routine = ( self._traverseAct || _traverseAct );

  _.assert( arguments.length === 1,'expects single argument' );
  _.assert( src instanceof self.Self || _.mapIs( src ),'expects instance of Class or map as argument' );

  var o = { dst : self, src : src, technique : 'object' };
  var it = _._cloner( routine,o );

  return routine.call( self, it );
}

//

/**
 * Copy data from one instance to another. Customizable static function.
 * @param {object} o - options.
 * @param {object} o.Prototype - prototype of the class.
 * @param {object} o.src - src isntance.
 * @param {object} o.dst - dst isntance.
 * @param {object} o.constitutes - to constitute or not fields, should be off for serializing and on for deserializing.
 * @method copyCustom
 * @memberof wCopyable#
 */

function copyCustom( o )
{
  var self = this;
  var routine = ( self._traverseAct || _traverseAct );

  _.assert( arguments.length == 1 );

  if( o.dst === undefined )
  o.dst = self;

  var it = _._cloner( copyCustom,o );

  return routine.call( self, it );
}

copyCustom.iterationDefaults = Object.create( _._cloner.iterationDefaults );
copyCustom.defaults = _.mapSupplementOwn( Object.create( _._cloner.defaults ),copyCustom.iterationDefaults );

//

function copyDeserializing( o )
{
  var self = this;

  _.assertMapHasAll( o,copyDeserializing.defaults )
  _.assertMapHasNoUndefine( o );
  _.assert( arguments.length == 1 );
  _.assert( _.objectIs( o ) );

  var optionsMerging = Object.create( null );
  optionsMerging.src = o;
  optionsMerging.proto = Object.getPrototypeOf( self );
  optionsMerging.dst = self;
  optionsMerging.deserializing = 1;

  var result = _.cloneObjectMergingBuffers( optionsMerging );

  return result;
}

copyDeserializing.defaults =
{
  descriptorsMap : null,
  buffer : null,
  data : null,
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneObject
 * @memberof wCopyable#
 */

function cloneObject( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.routineOptions( cloneObject,o );

  var it = _._cloner( cloneObject,o );

  return self._cloneObject( it );
}

cloneObject.iterationDefaults = Object.create( _._cloner.iterationDefaults );
cloneObject.defaults = _.mapSupplementOwn( Object.create( _._cloner.defaults ),cloneObject.iterationDefaults );
cloneObject.defaults.technique = 'object';

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method _cloneObject
 * @memberof wCopyable#
 */

function _cloneObject( it )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( it.iterator.technique === 'object' );

  /* */

  if( !it.dst )
  {

    dst = it.dst = new it.src.constructor( it.src );
    if( it.dst === it.src )
    {
      debugger;
      dst = it.dst = new it.src.constructor();
      it.dst._traverseAct( it );
    }

  }
  else
  {

    debugger;
    it.dst._traverseAct( it );

  }

  return it.dst;
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneData
 * @memberof wCopyable#
 */

function cloneData( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o.src === undefined )
  o.src = self;

  var it = _._cloner( cloneData,o );

  return self._cloneData( it );
}

cloneData.iterationDefaults = Object.create( _._cloner.iterationDefaults );
cloneData.iterationDefaults.dst = Object.create( null );
cloneData.iterationDefaults.copyingAggregates = 3;
cloneData.iterationDefaults.copyingAssociates = 0;
cloneData.defaults = _.mapSupplementOwn( Object.create( _._cloner.defaults ),cloneData.iterationDefaults );
cloneData.defaults.technique = 'data';

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method _cloneData
 * @memberof wCopyable#
 */

function _cloneData( it )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( it.iterator.technique === 'data' );

  return self._traverseAct( it );
}

//

function _traverseActPre( it )
{
  var self = this;

  _.assert( it );
  _.assert( arguments.length === 1 );

  /* adjust */

  if( it.src === undefined )
  debugger;
  if( it.src === undefined )
  it.src = self;

  if( it.iterator.technique === 'data' )
  if( !it.dst )
  it.dst = Object.create( null );

  if( !it.proto && it.dst )
  it.proto = Object.getPrototypeOf( it.dst );
  if( !it.proto && it.src )
  it.proto = Object.getPrototypeOf( it.src );

}

//

/**
 * Copy data from one instance to another. Customizable static function.
 * @param {object} o - options.
 * @param {object} o.Prototype - prototype of the class.
 * @param {object} o.src - src isntance.
 * @param {object} o.dst - dst isntance.
 * @param {object} o.constitutes - to constitute or not fields, should be off for serializing and on for deserializing.
 * @method _traverseAct
 * @memberof wCopyable#
 */

var _empty = Object.create( null );
function _traverseAct( it )
{
  var self = this;

  /* adjust */

  self._traverseActPre( it );

  _.assert( it.proto );

  /* var */

  var proto = it.proto;
  var src = it.src;
  var dst = it.dst;
  // var dst = it.dst = it.dst || self;
  var dropFields = it.dropFields || _empty;
  var Composes = proto.Composes || _empty;
  var Aggregates = proto.Aggregates || _empty;
  var Associates = proto.Associates || _empty;
  var Restricts = proto.Restricts || _empty;
  var Medials = proto.Medials || _empty;

  /* verification */

  _.assertMapHasNoUndefine( it );
  _.assertMapHasNoUndefine( it.iterator );
  _.assert( arguments.length === 1 );
  _.assert( src !== dst );
  _.assert( src );
  // _.assert( dst );
  _.assert( proto );
  _.assert( _.strIs( it.path ) );
  _.assert( _.objectIs( proto ),'expects object ( proto ), but got',_.strTypeOf( proto ) );
  _.assert( !it.customFields || _.objectIs( it.customFields ) );
  _.assert( it.level >= 0 );
  _.assert( _.numberIs( it.copyingDegree ) );
  _.assert( self.__traverseAct );

  if( _.instanceIsStandard( src ) )
  _.assertMapOwnOnly( src, Composes, Aggregates, Associates, Restricts,'options( instance ) should not have fields' );
  else
  _.assertMapOwnOnly( src, Composes, Aggregates, Associates, Medials,'options( map ) should not have fields' );

  /* */

  if( it.dst === null )
  {

    dst = it.dst = new it.src.constructor( it.src );
    if( it.dst === it.src )
    {
      debugger;
      dst = it.dst = new it.src.constructor();
      self.__traverseAct( it );
    }

  }
  else
  {

    self.__traverseAct( it );

  }

  /* done */

  return dst;
}

_traverseAct.iterationDefaults = Object.create( _._cloner.iterationDefaults );
_traverseAct.defaults = _.mapSupplementOwn( Object.create( _._cloner.defaults ) , _traverseAct.iterationDefaults );

//

function __traverseAct( it )
{

  /* var */

  var proto = it.proto;
  var src = it.src;
  var dst = it.dst = it.dst;
  var dropFields = it.dropFields || _empty;
  var Composes = proto.Composes || _empty;
  var Aggregates = proto.Aggregates || _empty;
  var Associates = proto.Associates || _empty;
  var Restricts = proto.Restricts || _empty;
  var Medials = proto.Medials || _empty;

  /* copy facets */

  function copyFacets( screen,copyingDegree )
  {

    _.assert( _.numberIs( copyingDegree ) );
    _.assert( it.dst === dst );
    _.assert( _.objectIs( screen ) || !copyingDegree );

    if( !copyingDegree )
    return;

    newIt.screenFields = screen;
    newIt.copyingDegree = Math.min( copyingDegree,it.copyingDegree );
    newIt.instanceAsMap = 1;

    _.assert( it.copyingDegree === 3,'not tested' );
    _.assert( newIt.copyingDegree === 1 || newIt.copyingDegree === 3,'not tested' );

    /* copyingDegree applicable to fields, so increment is needed */

    if( newIt.copyingDegree === 1 )
    newIt.copyingDegree += 1;

    _._traverseMap( newIt );

  }

  /* */

  var newIt = it.iterationClone();

  copyFacets( Composes,it.copyingComposes );
  copyFacets( Aggregates,it.copyingAggregates );
  copyFacets( Associates,it.copyingAssociates );
  copyFacets( _.mapScreen( Medials,Restricts ),it.copyingMedialRestricts );

  if( !_.instanceIsStandard( it.src ) )
  copyFacets( Medials,it.copyingMedials );

  copyFacets( Restricts,it.copyingRestricts );
  copyFacets( it.customFields,it.copyingCustomFields );

  /* done */

  return dst;
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneSerializing
 * @memberof wCopyable#
 */

function cloneSerializing( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o.src === undefined )
  o.src = self;

  if( o.copyingMedials === undefined )
  o.copyingMedials = 0;

  if( o.copyingMedialRestricts === undefined )
  o.copyingMedialRestricts = 1;

  var result = _.cloneDataSeparatingBuffers( o );

  return result;
}

cloneSerializing.defaults =
{
  copyingMedialRestricts : 1,
}

cloneSerializing.defaults.__proto__ = _.cloneDataSeparatingBuffers.defaults;

//

/**
 * Clone instance.
 * @method clone
 * @param {object} [self] - optional destination
 * @memberof wCopyable#
 */

function clone()
{
  var self = this;

  _.assert( arguments.length === 0 );
  // _.assert( arguments.length <= 1 );

  // if( !dst )
  // {
    var dst = new self.constructor( self );
    _.assert( dst !== self );
    // if( dst === self )
    // {
    //   dst = new self.constructor();
    //   dst.copy( self );
    // }
  // }
  // else
  // {
  //   dst.copy( self );
  // }

  return dst;
}

//

function cloneOverriding( override )
{
  var self = this;

  _.assert( arguments.length <= 1 );

  if( !override )
  {
    debugger;
    var dst = new self.constructor( self );
    _.assert( dst !== self );
    // if( dst === self )
    // {
    //   dst = new self.constructor();
    //   dst.copy( self );
    // }
    return dst;
  }
  else
  {
    var src = _.mapScreen( self.Self.copyableFields,self );
    _.mapExtend( src,override );
    var dst = new self.constructor( src );
    _.assert( dst !== self && dst !== src );
    return dst;
  }

}

//

function cloneEmpty()
{
  var self = this;
  return self.clone();
}

// --
// etc
// --

/**
 * Gives descriptive string of the object.
 * @method toStr
 * @memberof wCopyable#
 */

function toStr( o )
{
  var self = this;
  var result = '';
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !o.jstructLike && !o.jsonLike )
  result += self.nickName + '\n';

  var fields = self.loggableFields;

  var t = _.toStr( fields,o );
  _.assert( _.strIs( t ) );
  result += t;

  return result;
}

// --
// tester
// --

function _equalAre_functor( functorOptions )
{
  _.assert( arguments.length <= 1 );

  functorOptions = _.routineOptions( _equalAre_functor,functorOptions || Object.create( null ) );

  return function _equalAre( src1,src2,o )
  {

    _.assert( arguments.length === 3 );

    if( !src1 )
    return false;

    if( !src2 )
    return false;

    if( o.strict && !o.contain )
    if( src1.constructor !== src2.constructor )
    return false;

    if( o.contain )
    {
      for( var c in src2 )
      {
        if( !_._entityEqual( src1[ c ],src2[ c ],o ) )
        return false;
      }
      return true;
    }

    /* */

    for( var f in functorOptions )
    if( functorOptions[ f ] )
    for( var c in src1[ f ] )
    {
      if( !_._entityEqual( src1[ c ],src2[ c ],o ) )
      return false;
    }

    return true;
  }

}

_equalAre_functor.defaults =
{
  Composes : 1,
  Aggregates : 1,
  Associates : 1,
  Restricts : 0,
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method equalWith
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var _equalAre = _equalAre_functor();

//

function equalWith( ins,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( self._equalAre );

  var o = o || Object.create( null );
  _._entityEqualIteratorMake( o );

  return self._equalAre( self,ins,o );
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method identicalWith
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

function identicalWith( src,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  var o = o || Object.create( null );
  o.strict = 1;
  _._entityEqualIteratorMake( o );

  return self.equalWith( src,o );
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method equivalentWith
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

function equivalentWith( src,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  var o = o || Object.create( null );
  o.strict = 0;
  _._entityEqualIteratorMake( o );

  return self.equalWith( src,o );
}

//

function instanceIs()
{
  _.assert( arguments.length === 0 );
  return _.instanceIs( this );
}

//

function prototypeIs()
{
  _.assert( arguments.length === 0 );
  return _.prototypeIs( this );
}

//

function constructorIs()
{
  _.assert( arguments.length === 0 );
  return _.constructorIs( this );
}

// --
// field
// --

/**
 * Get map of all fields.
 * @method _allFieldsGet
 * @memberof wCopyable
 */

function _allFieldsGet()
{
  var self = this;

  if( !self.instanceIs() )
  return _allFieldsStaticGet.call( self );

  _.assert( self.instanceIs() );

  var result = _.mapScreen( _allFieldsStaticGet.call( self ),self );

  return result;
}

//

/**
 * Get map of copyable fields.
 * @method _copyableFieldsGet
 * @memberof wCopyable
 */

function _copyableFieldsGet()
{
  var self = this;

  if( !self.instanceIs() )
  return _copyableFieldsStaticGet.call( self );

  _.assert( self.instanceIs() );

  var result = _.mapScreen( self.Self.copyableFields,self );
  return result;
}

//

/**
 * Get map of loggable fields.
 * @method _loggableFieldsGet
 * @memberof wCopyable
 */

function _loggableFieldsGet()
{
  var self = this;

  if( !self.instanceIs() )
  return _loggableFieldsStaticGet.call( self );

  _.assert( self.instanceIs() );

  var result = _.mapScreen( self.Self.loggableFields,self );
  return result;
}

//

function fieldDescriptorGet( nameOfField )
{
  var proto = _.prototypeGet( this );
  var report = Object.create( null );

  _.assert( _.strIsNotEmpty( nameOfField ) );
  _.assert( arguments.length === 1 );

  for( var f in _.ClassSubfieldsGroups )
  {
    var facility = _.ClassSubfieldsGroups[ f ];
    if( proto[ facility ] )
    if( proto[ facility ][ nameOfField ] !== undefined )
    report[ facility ] = true;
  }

  return report;
}

//

/**
 * Get map of all fields.
 * @method _allFieldsStaticGet
 * @memberof wCopyable#
 */

function _allFieldsStaticGet()
{
  return _.prototypeAllFieldsGet( this );
}

//

/**
 * Get map of copyable fields.
 * @method _copyableFieldsGet
 * @memberof wCopyable#
 */

function _copyableFieldsStaticGet()
{
  return _.prototypeCopyableFieldsGet( this );
}

//

/**
 * Get map of loggable fields.
 * @method _loggableFieldsGet
 * @memberof wCopyable#
 */

function _loggableFieldsStaticGet()
{
  return _.prototypeLoggableFieldsGet( this );
}

//

function hasField( fieldName )
{
  debugger;
  return _.prototypeHasField( this,fieldName );
}

// --
// class
// --

/**
 * Return own constructor.
 * @method _SelfGet
 * @memberof wCopyable#
 */

function _SelfGet()
{
  var result = _.constructorGet( this );
  return result;
}

//

/**
 * Return parent's constructor.
 * @method _ParentGet
 * @memberof wCopyable#
 */

function _ParentGet()
{
  var result = _.parentGet( this );
  return result;
}

// --
// name
// --

/**
 * Return name of class constructor.
 * @method _classNameGet
 * @memberof wCopyable#
 */

function _classNameGet()
{
  _.assert( this.constructor === null || this.constructor.name || this.constructor._name );
  return this.constructor ? this.constructor.name || this.constructor._name : '';
}

//

/**
 * Nick name of the object.
 * @method _nickNameGet
 * @memberof wCopyable#
 */

function _nickNameGet()
{
  var self = this;
  var result = ( self.key || self.name || '' );
  var index = '';
  if( _.numberIs( self.instanceIndex ) )
  result += '#in' + self.instanceIndex;
  if( Object.hasOwnProperty.call( self,'id' ) )
  result += '#id' + self.id;
  return self.className + '( ' + result + ' )';
}

//

function unameGet()
{
  var self = this;
  return self.className + '( ' + '#id' + self.id + ' )';
}


//

/**
 * Unique name of the object.
 * @method _uniqueNameGet
 * @memberof wCopyable#
 */

function _uniqueNameGet()
{
  var self = this;
  var result = '';
  var index = '';
  if( _.numberIs( self.instanceIndex ) )
  result += '#in' + self.instanceIndex;
  if( Object.hasOwnProperty.call( self,'id' ) )
  result += '#id' + self.id;
  return self.className + '( ' + result + ' )';
}

// --
// relationships
// --

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
}

var Medials =
{
}

var Statics =
{

  instanceIs : instanceIs,
  prototypeIs : prototypeIs,
  constructorIs : constructorIs,

  '_allFieldsGet' : _allFieldsStaticGet,
  '_copyableFieldsGet' : _copyableFieldsStaticGet,
  '_loggableFieldsGet' : _loggableFieldsStaticGet,

  hasField : hasField,

  '_SelfGet' : _SelfGet,
  '_ParentGet' : _ParentGet,
  '_classNameGet' : _classNameGet,

}

Object.freeze( Composes );
Object.freeze( Aggregates );
Object.freeze( Associates );
Object.freeze( Restricts );
Object.freeze( Medials );
Object.freeze( Statics );

// --
// proto
// --

var Supplement =
{

  init : init,
  finit : finit,
  finitedIs : finitedIs,

  extend : extend,
  copy : copy,

  copyCustom : copyCustom,
  copyDeserializing : copyDeserializing,

  _traverseActPre : _traverseActPre,
  _traverseAct : _traverseAct,
  __traverseAct : __traverseAct,

  cloneObject : cloneObject,
  _cloneObject : _cloneObject,

  cloneData : cloneData,
  _cloneData : _cloneData,

  cloneSerializing : cloneSerializing,
  clone : clone,
  cloneOverriding : cloneOverriding,
  cloneEmpty : cloneEmpty,


  // etc

  toStr : toStr,


  // tester

  _equalAre_functor : _equalAre_functor,
  _equalAre : _equalAre,
  equalWith : equalWith,
  identicalWith : identicalWith,
  equivalentWith : equivalentWith,

  instanceIs : instanceIs,
  prototypeIs : prototypeIs,
  constructorIs : constructorIs,


  // field

  '_allFieldsGet' : _allFieldsGet,
  '_copyableFieldsGet' : _copyableFieldsGet,
  '_loggableFieldsGet' : _loggableFieldsGet,
  fieldDescriptorGet : fieldDescriptorGet,


  // class

  '_SelfGet' : _SelfGet,
  '_ParentGet' : _ParentGet,


  // name

  '_classNameGet' : _classNameGet,
  '_nickNameGet' : _nickNameGet,
  '_uniqueNameGet' : _uniqueNameGet,

  unameGet : unameGet,


  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Medials : Medials,
  Statics : Statics,

}

//

var Self = _.mixinMake
({
  supplement : Supplement,
  _mixin : _mixin,
  name : 'wCopyable',
  nameShort : 'Copyable',
});

_global_[ Self.name ] = _[ Self.nameShort ] = Self;

//

_.assert( !Self.copy );
_.assert( Self.prototype.copy );
_.assert( Self.nameShort );
_.assert( Self._mixin );
_.assert( Self.mixin );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
