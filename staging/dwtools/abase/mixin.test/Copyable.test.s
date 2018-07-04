( function _Copyable_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wProto' );
  _.include( 'wCopyable' );
  _.include( 'wTesting' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// test
// --

function fields( test )
{
  var self = this;

  test.description = 'allFields and copyableFields should act differently with instance and prototype/constructor context';

  function BasicConstructor( o )
  {
    _.instanceInit( this );
    this.copy( o || {} );
  }

  var Composes =
  {
    co : 1,
  }

  var Associates =
  {
    as : 1,
  }

  var Aggregates =
  {
    ag : 1,
  }

  var Restricts =
  {
    re : 1,
  }

  var Medials =
  {
    re : 10,
  }

  var Statics =
  {
    st : 1,
  }

  var extend =
  {
    constructor : BasicConstructor,
    Composes : Composes,
    Aggregates : Aggregates,
    Associates : Associates,
    Medials : Medials,
    Restricts : Restricts,
    Statics : Statics,
  }

  _.classMake
  ({
    cls : BasicConstructor,
    extend : extend,
  });

  _.Copyable.mixin( BasicConstructor );

  var allFields =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 1,
  }

  var copyableFields =
  {
    co : 1,
    as : 1,
    ag : 1,
  }

  test.identical( BasicConstructor.allFields,allFields );
  test.identical( BasicConstructor.prototype.allFields,allFields );

  test.identical( BasicConstructor.copyableFields,copyableFields );
  test.identical( BasicConstructor.prototype.copyableFields,copyableFields );

  /* */

  var allFields =
  {
    co : 3,
    as : 3,
    ag : 3,
    re : 3,
  }

  var copyableFields =
  {
    co : 3,
    as : 3,
    ag : 3,
  }

  var instance = new BasicConstructor( allFields );

  var allFields =
  {
    co : 3,
    as : 3,
    ag : 3,
    re : 3,
  }

  test.identical( instance.allFields,allFields );
  test.identical( instance.copyableFields,copyableFields );

}

//

function equal( test )
{
  var self = this;

  test.description = 'allFields and copyableFields should act differently with instance and prototype/constructor context';

  function BasicConstructor( o )
  {
    _.instanceInit( this );
    this.copy( o || {} );
  }

  var Composes =
  {
    co : 0,
  }

  var Associates =
  {
    as : 0,
  }

  var Aggregates =
  {
    ag : 0,
  }

  var Restricts =
  {
    re : 0,
  }

  var Medials =
  {
    re : 10,
    me : 0,
  }

  var Statics =
  {
    st : 0,
  }

  var extend =
  {
    constructor : BasicConstructor,
    Composes : Composes,
    Aggregates : Aggregates,
    Associates : Associates,
    Medials : Medials,
    Restricts : Restricts,
    Statics : Statics,
  }

  _.classMake
  ({
    cls : BasicConstructor,
    extend : extend,
  });

  _.Copyable.mixin( BasicConstructor );

  var allFields =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 1,
    me : 1,
  }

  var copyableFields =
  {
    co : 1,
    as : 1,
    ag : 1,
  }

  var all1 = new BasicConstructor( allFields );
  var all2 = new BasicConstructor( allFields );
  var copyable1 = new BasicConstructor( copyableFields );
  var none1 = new BasicConstructor();

  test.description = 'identicalWith itself'; /* */

  var expected = true;
  var got = all1.identicalWith( all1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.identicalWith( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = none1.identicalWith( none1 );
  test.identical( got, expected );

  test.description = 'equivalentWith itself'; /* */

  var expected = true;
  var got = all1.equivalentWith( all1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.equivalentWith( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = none1.equivalentWith( none1 );
  test.identical( got, expected );

  test.description = 'contains itself'; /* */

  var expected = true;
  var got = all1.contains( all1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.contains( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = none1.contains( none1 );
  test.identical( got, expected );

  test.description = 'identicalWith trivial';

  var expected = true;
  var got = all1.identicalWith( all2 );
  test.identical( got, expected );

  var expected = true;
  var got = all2.identicalWith( all1 );
  test.identical( got, expected );

  test.description = 'equivalentWith trivial';

  var expected = true;
  var got = all1.equivalentWith( all2 );
  test.identical( got, expected );

  var expected = true;
  var got = all2.equivalentWith( all1 );
  test.identical( got, expected );

  test.description = 'contains trivial';

  var expected = true;
  var got = all1.contains( all2 );
  test.identical( got, expected );

  var expected = true;
  var got = all2.contains( all1 );
  test.identical( got, expected );

  test.description = 'identicalWith copyable';

  var expected = true;
  var got = all1.identicalWith( copyable1 );
  test.identical( got, expected );

  test.description = 'equivalentWith copyable';

  var expected = true;
  var got = all1.equivalentWith( copyable1 );
  test.identical( got, expected );

  test.description = 'contains copyable';

  var expected = true;
  var got = all1.contains( copyable1 );
  test.identical( got, expected );

  test.description = 'identicalWith map';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = true ;
  var got = all1.identicalWith( map,{ strictTyping : 0 } );
  test.identical( got, expected );

  test.description = 'not identicalWith map';

  var map =
  {
    co : 1,
    as : 1,
    ag : 5,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.identicalWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.description = 'not identicalWith map having redundant fields';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    x : 5,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.identicalWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.description = 'not equivalentWith map having redundant fields';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    x : 5,
  }

  var expected = false;
  var got = all1.equivalentWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.equivalentWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.description = 'not contains map having redundant fields';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    x : 5,
  }

  var expected = false;
  var got = all1.contains( map );
  test.identical( got, expected );

  test.description = 'not identicalWith map having restricts';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 5,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.identicalWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.description = 'not contains map having restricts';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 5,
  }

  var expected = false;
  var got = all1.contains( map );
  test.identical( got, expected );

  test.description = 'identicalWith map having medials';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    me : 5,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.identicalWith( map,{ strictTyping : 0 } );
  test.identical( got, expected );

  test.description = 'contains map having medials';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    me : 5,
  }

  var expected = false;
  var got = all1.contains( map );
  test.identical( got, expected );

  test.description = 'contains copyable';

  var expected = true;
  var got = all1.contains( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.contains( all1 );
  test.identical( got, expected );

}

// --
// define class
// --

var Self =
{

  name : 'Tools/base/CopyableMixin',
  silencing : 1,

  tests :
  {

    fields : fields,
    equal : equal

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
