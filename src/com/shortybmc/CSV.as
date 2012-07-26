﻿/**
 *   The csvlib is free software! Do what you want! No rights or other
 *   bull shit. Use it, or let it! PLEASE do not mail me on, to say "please
 *   change the license model of your software".
 *
 *	 Regards,
 *   Marco
 */

package com.shortybmc
{
	import com.utils.StringUtils;

	import flash.events.Event;

	
	
	/**
	 *   TODO Package description ...
	 * 
	 *   @author Marco Müller / Shorty
	 *   @see http://rfc.net/rfc4180.html RFC4180
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public class CSV
	{
		
		
		private var FieldSeperator		: String;
		private var FieldEnclosureToken : String;
		private var RecordsetDelimiter	: String;
		
		private var Header 				: Array;
		private var EmbededHeader 		: Boolean;
		private var HeaderOverwrite 	: Boolean;
		
		private var SortField			: *;
		private var SortSequence		: String;
		
		private var data				: *;
		
		
		/**
		 *   TODO Constructor description ...
		 * 
		 *   @param request URLRequest
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function CSV( data:String )
		{
			this.data = data;
			fieldSeperator 		= ';';
			fieldEnclosureToken = '"';
			recordsetDelimiter 	= '\r';
			
			header = new Array();
			embededHeader = true;
			headerOverwrite = false;
//			decode();
			fastDecode();
		}
		
		
		
		// -> getter
		
		
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get fieldSeperator() : String
		{
			return FieldSeperator;
		}
		
		
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get fieldEnclosureToken() : String
		{
			return FieldEnclosureToken;
		}
		
		
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get recordsetDelimiter() : String
		{
			return RecordsetDelimiter;
		}
		
		
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get embededHeader() : Boolean
		{
			return EmbededHeader;
		}
		
		
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get headerOverwrite()  : Boolean 
		{
			return HeaderOverwrite;
		}
		
		
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get header() : Array 
		{
			return Header;
		}
		
		
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get headerHasValues () : Boolean
		{
			var check : Boolean;
			try {
				if ( Header.length > 0 ) check = true;
			} catch ( e : Error ) {
				check = false;
			} finally {
				return check;
			}
		}
		
		
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get dataHasValues () : Boolean
		{
			var check : Boolean;
			try {
				if ( data.length > 0 ) check = true;
			} catch ( e : Error ) {
				check = false;
			} finally {
				return check;
			}
		}
		
		
		// -> setter
		
		
		
		/**
		 *   TODO Setter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function set fieldSeperator( value : String ) : void
		{
			FieldSeperator = value;
		}
		
		
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function set fieldEnclosureToken( value : String ) : void
		{
			FieldEnclosureToken = value;
		}
		
		
		
		/**
		 *   TODO Setter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function set recordsetDelimiter( value : String ) : void
		{
			RecordsetDelimiter = value;
		}
		
		
		
		/**
		 *   TODO Setter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function set embededHeader( value : Boolean ) : void
		{
			EmbededHeader = value;
		}
		
		
		
		/**
		 *   TODO Setter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function set headerOverwrite( value : Boolean ) : void
		{
			HeaderOverwrite = value;
		}
		
		
		
		/**
		 *   TODO Setter description ...
		 * 
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function set header( value : Array ) : void
		{
			if ( (!embededHeader && !headerHasValues) ||
				 (!embededHeader && headerHasValues && headerOverwrite) || headerOverwrite )
				   Header = value;
		}
		
		
		
		// -> Public methods
		
		
		
		/**
		 *   TODO Public method description ...
		 * 
		 *   @param index int
		 *   @return Array
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function getRecordSet( index : int ) : Array
		{
			if ( dataHasValues )
				 return data[ index ];
			else
				return null;
		}
		
		public function getData():Array{
			return data;
		}
		
		/**
		 *   TODO Public method description ...
		 * 
		 *   @param recordset Array
		 *   @param index *
		 *   @return no
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function addRecordSet( recordset : Array, index : * = null ) : void
		{
			if ( !dataHasValues )
				  data = new Array();
			
			if ( !index && index != 0 )
				  data.push( recordset );
			else
				  data.splice( index, 0, recordset );
		}
		
		
		
		/**
		 *   TODO Public method description ...
		 * 
		 *   @param startIndex int
		 *   @param endIndex int
		 *   @return Boolean
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function deleteRecordSet ( startIndex : int, endIndex : int = 1 ) : Boolean
		{
			if ( dataHasValues && startIndex < data.length && endIndex > 0 )
				 return data.splice( startIndex, endIndex );
			else
				 return false;
		}
		
		
		
		/**
		 *   TODO Public method description ...
		 * 
		 *   @param needle String or Array
		 *   @return Array
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function search ( needle : *, removeDuplicates : Boolean = true ) : Array
		{
			var result : Array = new Array();
			for each ( var i : Array in data ){
				if ( needle is Array ){
					 for each ( var j : String in needle )
						 if ( i.indexOf( String( j ) ) >= 0 )
							  result.push( i );}
				else
					if ( i.indexOf( String( needle ) ) >= 0 ){
					 	 result.push( i );}}
			if ( removeDuplicates && result.length > 2 )
				 var k : int = result.length -1;
				 while ( k-- ){
					 var l : int = result.length;
					 while ( --l > k )
						if ( result[ k ] == result[ l ] )
							 result.splice( l, 1 );}
			return result;
		}
		
		
		
		/**
		 *   TODO Private method description ...
		 * 
		 *   @param fieldNameOrIndex *
		 *   @param sequence String
		 *   @return no
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function sort( fieldNameOrIndex : * = 0, sequence : String = 'ASC' ) : void
		{
			SortSequence = sequence;
			if ( headerHasValues && header.indexOf( fieldNameOrIndex ) >=0 )
				 SortField = header.indexOf( fieldNameOrIndex );
			else
				 SortField = fieldNameOrIndex;
			if ( dataHasValues )
				 data.sort ( sort2DArray );
		}
		public static const SPLITLINE:String="\r\n";
		public static const SPLIT:String=";";
		public function fastDecode():void
		{
			var result : Array = [];
			var temp:Array=[];
			data=(data as String).replace(new RegExp("\n|\r\n", "g"), "\r");
//			(data as String).replace(new RegExp("\r\n", "g"), "___");
			result=data.toString().split( recordsetDelimiter );
			result.shift();
			data=[];
			for each(var str:String in result){
				temp=str.split(SPLIT);
				if(!temp||temp.length<=1)continue;
				(data as Array).push(temp);
			}
		}
		
		/**
		 *   TODO Public method description ...
		 * 
		 *   @param raw The sting to decode
		 *   @param event Never set this, its only for internal use
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function decode( event : Event = null ) : void
		{
			var count  : uint = 0;
			var result : Array = new Array ()	;	 
			data = data.toString().split( recordsetDelimiter );
			for(  var i : uint = 0; i < data.length; i++ )
			{
				if( !Boolean( count % 2 ) )
					 result.push( data[ i ] );
				else
					 result[ result.length - 1 ] += data[ i ];
				count += StringUtils.count( data[ i ] , fieldEnclosureToken );
			}
			result = result.filter( isNotEmptyRecord );
			result.forEach( fieldDetection );
			if ( embededHeader && headerOverwrite )
				   result.shift();
			else if ( embededHeader && headerHasValues )
				   result.shift();
			else if ( embededHeader )
				 	  Header = result.shift();
			data = result;
		}
		
		
		
		/**
		 *   TODO Public method description ...
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function encode () : void
		{
			var result : String = '';
			if ( headerHasValues && header.length > 0 )
			{
				 embededHeader = true;
				 data.unshift( header );
			}
			if ( dataHasValues )
				 for each ( var recordset : Array in data )
				 	 result += recordset.join( fieldSeperator ) + recordsetDelimiter;
			data = result;
		}
		
		
		
		// -> private methods
		
		
		
		/**
		 *   TODO Private method description ...
		 * 
		 *   @param element *
		 *   @param index int
		 *   @param arr Array
		 *   @return Boolean true if recordset has values, false if not
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		private function fieldDetection( element : *, index : int, arr : Array ) : void
		{	
			var count  : uint  = 0;
			var result : Array = new Array ();
			var tmp    : Array = element.split( fieldSeperator );
			for( var i : uint = 0; i < tmp.length; i++ )
			{
				if( !Boolean( count % 2 ) )
					 result.push( StringUtils.trim( tmp[ i ] ) );
				else
					 result[ result.length - 1 ] += fieldSeperator + tmp[ i ];
				count += StringUtils.count( tmp[ i ] , fieldEnclosureToken );
			}
			arr[ index ] = result;
		}
		
		
		
		/**
		 *   TODO Private method description ...
		 * 
		 *   @param a Array
		 *   @param b Array
		 *   @return Number
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		private function sort2DArray( a : Array, b : Array ) : Number
		{
			var n : int = 0;
			var r : int = SortSequence == 'ASC' ? -1 : 1;
			if ( String( a[ SortField ] ) < String( b[ SortField ]) )
				n = r;
			else if ( String( a[ SortField ] ) > String( b[ SortField ] ) )
				n = -r;
			else
				n = 0;
			return n;
		}
		
		
		/**
		 *   TODO Private method description ...
		 * 
		 *   @param element *
		 *   @param index int
		 *   @param arr Array
		 *   @return Boolean true if recordset has values, false if not
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		private function isNotEmptyRecord( element : *, index : int, arr : Array ) : Boolean
		{
			return Boolean( StringUtils.trim( element ) );
		}
		
		
		
		// -> deprecated / helper methods, not inside final release
		
		
		
		public function dump() : String
		{
			var  result : String = 'data:Array -> [\r';
			for ( var i : int = 0; i < data.length; i++ )
			{
				result += '\t[' + i + ']:Array -> [\r';
				for (var j : uint = 0; j < data[i].length; j++ ) result += '\t\t[' + j + ']:String -> ' + data[ i ][ j ] + '\r'
				result += ( '\t]\r' );
			}
			result += ']\r';
			return result;
		}
		
	}
	
}