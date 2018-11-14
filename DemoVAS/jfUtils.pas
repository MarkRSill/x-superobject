{!!180928 jfutils  jjf Added a simple BracketSql function for Sqlite.}
{!!180925 jfutils  jjf Added a TouchFile function.}
{!!180905 jfutils  jjf improved ShellExecute to allow HIDE, and SaveStringToFile to allow prepending.}
{!!180824 jfutils  gew DC-791 Added DeleteOlderFiles and deprecated LeftStr and RightStr }
{!!180822 jfutils  jjf DC-788 Refactored jfutils.sqlquote to SQLSingleQuote. }
{!!180814 jfutils  gew DC-180/Bugz-9160 - DC Taking over Excel, etc. - Tapplication vs Application }
{!!180814 jfutils  gew DC-180/Bugz-9160 - DC Taking over Excel, etc. }
{!!180712 jfutils  gew DC-680/Bugz-10165 - added PatchAsciiFilename}
{!!180711 jfutils  jjf added function RemoveLeadingBackSlash}
{!!180628 jfutils  gew DC-606 add ExtractInt to get integers from strings with somewhat strict edit }
{!!180612 jfutils  gew added support for BOM header detection and removal - converting to UTF-8}
{!!180518 jfutils  mrs removed unnecessary reference to dcroot }
{!!180508 jfutils  gew revised PosCount and eliminated IfThen adding deprecated IIF versions }
{!!180517 jfutils  jjf added EnableWindow (Thanks, Gary)}
{!!180411 jfutils  gew added FileBytesIdentical}
{!!180411 jfutils  mrs DC-412 - Replace code for ReplaceString with StringReplace call and deprecate }
{!!180410 jfutils  mrs DC-412 - Add EscapeAmpersands function used to correct captions with & symbol }
{!!180405 jfutils  mrs Add THugeSet for record based sets not to be confused with TBigSet class }
{!!180404 jfutils  jjf Added a default -1 for List Item Count}
{!!180322 jfutils  mrs Replace deprecated calls to FileAge with updated FileAge overload }
{!!180322 jfutils  mrs Add Coalesce SQL like function which returns the first non blank string }
{!!180220 jfutils  mrs deprecated several functions due to conflicts with TPStuff }
{!!180210 jfutils  jjf Refactored sqldate to sqllitedate}
{!!180205 jfutils  mrs Added default params and optional alternate quote character}
{!!180117 jfutils  jjf Added FirstChar. ListItemCount}
{!!180115 jfutils  jjf function LoadStringFromFile(FileNameStr: string; index : integer = -1): string;}

{!!171208 jfutils  jjf added Append_YYYYMMDDHHNN function for dbSquirrel and NEDAP.}
{!!171207 jfutils  mrs Corrected FillStr function that was failing to fill string properly in XE2}
{!!171012 jfutils  jjf Added ItoB;}
{!!170914 jfutils  jjf Added RemoveNumbers;}
{!!170818 jfutils  jjf Added LastChar}
{!!170711 jfutils  jjf Added LoadStringFromFile}
{!!170615 jfutils  jjf Minor refactoring.}
{!!170419 jfutils  jjf Added a switch to printer function, returning printer index. VCL only.}
{!!170404 jfutils  jjf quick rewrite of UpperCaseFirstLetterEachWord to fix double embedded spaces}
{!!170130 jfutils  jjf Added defaults for s2i, stoi.}
{!!161216 jfutils  jjf Bugz 9308, Duplicate shortcuts were being created.}
{!!160518 jfutils  jjf I wrapped 4 Unused var declarations for "i" with IFDEF VER150 to squash compiler warnings. }
{!!160502 jfutils  jjf Added AddForwardSlash and RemoveForwardSlash, mimicking the BackSlash equivalents }
{!!160423 jfutils  jjf Added CreateShortcut from DCStartup. and ListGetIndexByItem }
{!!160408 jfutils  jjf Added the bulletproof SetFocusTo(). }
{!!160406 jfutils  jjf Made VER150 compatible. }
{!!160325 jfutils  jjf Extended FindFiles to check for olderthan and newerthan }
{!!160218 jfutils  jjf Added StoByte function to work with sets of byte. }
{!!160126 jfutils  jjf Added GetShortPath  (as, "C:\...\Actchange.txt" for better display }
{@@150925 jfutils  jjf Bugz ???? - my can't-do-without set if utilities}
unit jfutils;

{ .$DEBUGINFO ON }
{ .$LOCALSYMBOLS ON }
{ .$YD }
{ ***********************************************************
  * *                  JFUtils
  * *           Author:  Jay Faubion
  * *
  * *      AUGUST 2015 -- MADE UNICODE-FRIENDLY
  *********************************************************** }
{ .$DEBUGINFO OFF }
{ .$LOCALSYMBOLS OFF }
{ .$YD OFF }

interface

uses Windows, Classes, Graphics, JPeg, SysUtils, Controls, DateUtils, IOUtils;
{$J+}
const
  CR = #13;
  LF = #10;
  CRLF = #13#10;
  SINGLEQUOTE = #39;
  DOUBLEQUOTE = #34;
  BACKSPACE = #8;
  TAB = #9;
  ENTER = #13;
  ESCAPE = #27;

  FieldChar: char = '_';
  ZeroSupress: Boolean = False;
  FT: array [False .. True] of string = ('F', 'T');
  FALSETRUE: array [False .. True] of string = ('false', 'true');
  ZERO_ONE: array [False .. True] of string = ('0', '1');
  N_Y: array [False .. True] of string = ('N', 'Y');
  NO_YES: array [False .. True] of string = ('NO', 'YES');
  SUCCESSFUL: array [False .. True] of string = ('NOT SUCCESSFUL',
    'SUCCESSFUL');
  WITHERRORS: array [False .. True] of string = ('With NO Errors',
    'With Errors');

  MONTHNAMES: array [1 .. 12] of string = ('JAN', 'FEB', 'MAR', 'APR', 'MAY',
    'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC');

  ArrayFiftyStates: array [0 .. 49, 0 .. 1] of string = (('ALABAMA', 'AL'),
    ('ALASKA', 'AK'), ('ARIZONA', 'AZ'), ('ARKANSAS', 'AR'),
    ('CALIFORNIA', 'CA'), ('COLORADO', 'CO'), ('CONNECTICUT', 'CT'),
    ('DELAWARE', 'DE'), ('FLORIDA', 'FL'), ('GEORGIA', 'GA'), ('HAWAII', 'HI'),
    ('IDAHO', 'ID'), ('ILLINOIS', 'IL'), ('INDIANA', 'IN'), ('IOWA', 'IA'),
    ('KANSAS', 'KS'), ('KENTUCKY', 'KY'), ('LOUISIANA', 'LA'), ('MAINE', 'ME'),
    ('MARYLAND', 'MD'), ('MASSACHUSETTS', 'MA'), ('MICHIGAN', 'MI'),
    ('MINNESOTA', 'MN'), ('MISSISSIPPI', 'MS'), ('MISSOURI', 'MO'),
    ('MONTANA', 'MT'), ('NEBRASKA', 'NE'), ('NEVADA', 'NV'),
    ('NEW HAMPSHIRE', 'NH'), ('NEW JERSEY', 'NJ'), ('NEW MEXICO', 'NM'),
    ('NEW YORK', 'NY'), ('NORTH CAROLINA', 'NC'), ('NORTH DAKOTA', 'ND'),
    ('OHIO', 'OH'), ('OKLAHOMA', 'OK'), ('OREGON', 'OR'),
    ('PENNSYLVANIA', 'PA'), ('RHODEISLAND', 'RI'), ('SOUTH CAROLINA', 'SC'),
    ('SOUTH DAKOTA', 'SD'), ('TENNESSEE', 'TN'), ('TEXAS', 'TX'),
    ('UTAH', 'UT'), ('VERMONT', 'VT'), ('VIRGINIA', 'VA'), ('WASHINGTON', 'WA'),
    ('WESTVIRGINIA', 'WV'), ('WISCONSIN', 'WI'), ('WYOMING', 'WY'));

type

  TObjStringList = class(TStringList)
  public
    procedure Clear; override;
    procedure Delete(Index: integer); override;
    destructor Destroy; override;
  end;

  TObjList = class(TList)
  public
    procedure Clear; override;
    procedure Delete(Index: integer); virtual;
    destructor Destroy; override;
  end;

  TOpSysTypes = (OSWin95, OSWin98, OSWin98SE, OSWinME, OSWinNT, OSWin2000,
    OSWinXP, OSUnknown);

const
  // The constants here are for the CRC-32 generator polynomial, as defined in the Microsoft
  // Systems Journal, March 1995, pp. 107-108
  PolyTable: array [0 .. 255] of DWORD = ($00000000, $77073096, $EE0E612C,
    $990951BA, $076DC419, $706AF48F, $E963A535, $9E6495A3, $0EDB8832, $79DCB8A4,
    $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91, $1DB71064,
    $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63,
    $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447,
    $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3,
    $45DF5C75, $DCD60DCF, $ABD13D59, $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F, $2802B89E, $5F058808, $C60CD9B2,
    $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,

    $76DC4190, $01DB7106, $98D220BC, $EFD5102A, $71B18589, $06B6B51F, $9FBFE4A5,
    $E8B8D433, $7807C9A2, $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB, $086D3D2D,
    $91646C97, $E6635C01, $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED,
    $1B01A57B, $8208F4C1, $F50FC457, $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
    $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65, $4DB26158, $3AB551CE, $A3BC0074,
    $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB, $4369E96A, $346ED9FC,
    $AD678846, $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9, $5005713C,
    $270241AA, $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B,
    $C0BA6CAD,

    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $04DB2615,
    $73DC1683, $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D,
    $0A00AE27, $7D079EB1, $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D,
    $806567CB, $196C3671, $6E6B06E7, $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
    $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8, $A1D1937E, $38D8C2C4,
    $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B, $D80D2BDA, $AF0A1B4C,
    $36034AF6, $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79, $CB61B38C,
    $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B,
    $5BDEAE1D,

    $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9, $EB0E363F, $72076785,
    $05005713, $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38, $92D28E9B, $E5D5BE0D,
    $7CDCEFB7, $0BDBDF21, $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD,
    $F6B9265B, $6FB077E1, $18B74777, $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45, $A00AE278, $D70DD2EE, $4E048354,
    $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB, $AED16A4A, $D9D65ADC,
    $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9, $BDBDF21C,
    $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B,
    $2D02EF8D);

type
  THugeSet = record
  private
    const Mask: array[0..15] of Word = ($1, $2, $4, $8, $10, $20, $40, $80, $100, $200, $400, $800, $1000, $2000, $4000, $8000);
    function GetValue(n: Word): Boolean;
    procedure SetValue(n: Word; const Value: Boolean);
  public
    Values: array[0..Pred(4096)] of Word; // up to 65536 set elements with size of 4096 (max)  64 provides 1024 bits
    procedure Clear;
    procedure SetAll;
    procedure Add(n: Word); overload;
    procedure Add(const items: array of Word); overload;
    procedure Del(n: Word); overload;
    procedure Del(const items: array of Word); overload;
    function InSet(n: Word): Boolean;
    function AllSet: Boolean;
    function IsEmpty: Boolean;

    property Value[n: Word]: Boolean read GetValue write SetValue; default;
  end;

  // ----------------------------------crc32----------------------------------
  TInteger8 = Int64; // Delphi 5

  // *** Pascal string functions ***

function Add_BackSlash(const S: string): string; deprecated 'use AddTrailingPathDelimiter or TPStuff AddBackSlash()';
function RemoveLeadingBackSlash(const S: string): string;
function AddForwardSlash(const S: string): string;

function BoolValue(aBool: Boolean): string; // returns 'true' or 'false' /jfw
function FormatPhoneNumber(PhoneStr: string): string;
function GetCurLine(const S: string; Position: integer): string;
function GetStrAllocSize(const S: string): longint;
// returns the memory allocation size of a given string.
function GetStrRefCount(const S: string): longint;
// returns the reference count of a given string.
function IIfDate(aBool: Boolean; aTrueDate, aFalseDate: tDatetime): tDatetime;
function IIfDouble(aBool: Boolean; const aTrueStrg, aFalseStrg: double): double;
function IIfInt(aBool: Boolean; aTrueInt, aFalseInt: integer): integer;
function IIfStrg(aBool: Boolean; const aTrueStrg, aFalseStrg: string): string;
function IsEmptyString(aStr: string; ignoreWhitespace: Boolean = True): Boolean;
function IsUpper(myChar: char): Boolean;
function IsLower(myChar: char): Boolean;
function LastPos(const SubStr, S: string): integer;
// LastPos finds the last occurence of SubStr in S

function LeftStr(aStr: string; Chars: integer): string; deprecated 'use SysUtils.LeftStr';
function LeftEqStr(subStr, srcStr: string; CaseInsensitive : Boolean = false): Boolean;
function RightStr(aStr: string; Chars: integer): string; deprecated 'use SysUtils.RightStr';

function RemoveControlCharacters(S: string): string;
// strips out all control chars (< #20)
function ReverseStr(const S: string): string;
// reverses the characters in a string, and returns new string
function RemoveBackSlash(const S: string): string;
function RemoveForwardSlash(const S: string): string;

function RemoveWSDLFromURL(URLIn: string): string;
function UpperCaseFirstLetterEachWord(aStr: String): String;
function ZeroLen(const aStr: string): Boolean;

function GetNodesFromXML(const aXML: string; var aNodes: TStringList): integer;
function ShiftStateToString(Shift: TShiftState): string;

procedure DecStrLen(var S: string; DecBy: integer);
// decrements the length of a string
procedure RealizeLength(var S: string);
// RealizeLength sets string length to null-terminated length.
function RemoveSpaces(const S: string): string;

// *** PChar string functions ***

procedure StrGetCurLine(StartPos, CurPos: PChar; TotalLen: integer;
  var LineStart: PChar; var LineLen: integer);
{ StrGetCurLine assumes StartPos is a pointer to a long string and
  CurPos points to any character in that string (up to TotalLen bytes
  away from StartPos).  This procedure returns the CRLF-delimited
  line of text in LineStart which holds char CurPos^.  The length of
  that line is given by LineLen. }
function StrLastPos(Str1, Str2: PChar): PChar;
// finds the last occurance of Str2 in Str1
procedure StrReverse(P: PChar); // Reverses the characters in a string

// String Functions

function AddDelim(const List, Value: string; Delimiter: string = ',')
  : string; overload;
function AddDelim(const List: string; const Value: double;
  Delimiter: string = ','): string; overload;
function AddDelim(const List: string; const Value: integer;
  Delimiter: string = ','): string; overload;
function All_Numeric(Source: string): Boolean; deprecated 'use TPStuff AllNumeric()';
function AllNumericOrX(Source: string): Boolean;
function AllUnsignedNumeric(Source: string): Boolean;
function AsChar(AString: string): char;
function AsWord(aInt: integer): word;
function Between(const Value, ValLow, ValHigh: double;
  AllowBlank: Boolean = True): Boolean; overload;
function Between(const Value, ValLow, ValHigh: integer;
  AllowBlank: Boolean = True): Boolean; overload;
function Between(const Value, ValLow, ValHigh: string;
  AllowBlank: Boolean = True): Boolean; overload;
function BtoH(Source: byte): string;
function BtoS(Source: Boolean; S: integer = 3): string;
function BtoI(b: Boolean): integer;
function ItoB(i: Integer): boolean;
function CenterStr(Source: string; Len: byte): string;
function CheckSum(Source: string): longint;
function CodeToAscii(Code: Ansistring; Offset: byte): Ansistring;
function Base64Decode(S: string): string;
function Base64Encode(S: string): string;

// untested
function NotZero(NumStr: string): Boolean; overload;
function NotZero(NumInt: integer): Boolean; overload;
function IsZero(NumStr: string): Boolean; overload;
function IsZero(NumInt: integer): Boolean; overload;
function PosCount(const SubStr: string; S: string;
  CaseSensitive: Boolean = False): integer;
function PosNum(const SubStr: string; S: string; FindPos: integer;
  CaseSensitive: Boolean = False): integer;
//

// function FindIn(const SubStr: string; S: string; CaseSensitive: boolean = false): boolean;
function Contains(const SubStr: string; S: string;
  CaseSensitive: Boolean = False): Boolean; overload;
function Contains(const SubStr: string; S: string; var SubIndex: integer)
  : Boolean; overload;
function SimpleEncrypt(Source: string): string;
function EndStr(Source: string): byte;
function FillStr(const Source: string; Len: byte): string;
function FirstWord(Source: string): string;
function FmtLongZuluDateString(aStr: string): String;
function FmtDateTime(const Format: string; DateTime: tDatetime): string;
function FmtDateTimeHMSZ(DateTime: tDatetime): string;
function FmtDateTimeSqlLite(dt: TDateTime): string;
function FmtDateSqlLite(dt: TDateTime): string;
function FmtTwoDecimalPlaces(d: double): string; overload;
function FmtTwoDecimalPlaces(S: string): string; overload;
function FmtStr(const Source, Mask: string; ExitPos: Boolean = False): string;
function Hex2Integer(const S: string): integer; deprecated 'use TPStuff HexToInt()';
function IIfThen(Xpression: Boolean; const Result1: double; const Result2: double = 0): double; overload; deprecated 'use Math.IfThen';
function IIfThen(Xpression: Boolean; const Result1: integer; const Result2: integer = 0): integer; overload; deprecated 'use Math.IfThen';
function IIfThen(Xpression: Boolean; const Result1: string; const Result2: string = ''): string; overload;  deprecated 'use StrUtils.IfThen';
function InCommandLine(Source: string): Boolean;
function InStr(const SbSt: string; S: string; const Start: integer): integer;
function IsFloatStr(Source: string; var Num: double): Boolean;
function IsInteger(Source: string): Boolean;
function IsNumber(Source: string; var Num: integer): Boolean;
function ItoF(Source: integer; S: integer; Fmt: string): string;
function ItoH(Source: SmallInt): string;
function I2S(S: integer): string; overload;
function ItoS(S: integer): string; overload;
function ItoS(Source: integer; S: integer): string; overload;
function StoIS(Source: string): string; // strips '0001' to '1'
function LastWord(Source: string): string;
function LeftJustStr(Source: string; Len: byte): string;
function HTTPEncode1(const aStr: string): string;
function HTTPEncode2(const aStr: string): string;
function KeyboardValue(aKey: word): string;
function LongDateTimeStrToDateTime(aLongStr: string): tDatetime;
// 2011-04-06T13:25:18-04:00
function DateTimeToLongDateTimeStr(aDate: tDatetime): string;
// 2011-04-06T13:25:18
function ListItemCount(List: String; const delimeter: string = ','): integer;
function ListGetItemByIndex(List: String; const idx: integer; const delimeter: string = ','): string;
function ListGetIndexByItem(List: String; const item : String; const delimeter: string = ','): integer;
function ListSetItemAtIndex(var List: String; const newItem: string; const idx: integer; const delimeter: string = ','): Boolean;
function ListGetAt(List: string; const Position: integer; const Delimiter: string = ','): string;
function ListLen(List: string; const Delimiter: string = ','): integer;
function ListSetAt(List: string; const Position: integer; const Value: string;
  const Delimiter: string = ','): string;
function ListToDelim(const List: string; Delimiter: string): string;
function LPad(Source: string; Len: byte; Filler: char = ' '): string;
function Lset(const Source: string; const Len: integer): string;
function LtoH(Source: integer): string;
function LStrTrim(Source: string): string;
function OnlyNumbers(Source: string): string;
function PadChar(Source: string; Ch: char; Len: byte): string;
function PadRight(Source: string; Ch: char; Len: byte): string;
function LZeroFill(aStr: string; Len: integer): string;
function FirstChar(const aStr: String): string;
function LastChar(const aStr: String): string;
function RemoveLastChar(const LastChar: string; const SourceStr: string): string; overload;
function RemoveLastChar(const LastChar: char; const SourceStr: string): string; overload;
function ReplaceChar(FindChar, NewChar: char; SourceStr: string): string;
function ReplaceString(const Source, FindStr, ReplStr: string): string; deprecated 'use SysUtils.StringReplace';
function RightJustStr(Source: string; Len: byte): string;
function RPad(Source: string; Len: byte; Filler: char = ' '): string;
function RSet(const Source: string; const Len: integer): string;
function RtoD(Source: double; S, d: integer): string;
function RtoF(Source: double; S, d: integer; Fmt: string): string;
function RtoR(Source: double; d: integer): double;
function RtoS(Source: double; S, d: integer): string; overload;
function StringIsQuoted(aStr: string; dblQuote : boolean = true): Boolean;
function RemoveQuotes(aStr: string; dblQuote : boolean = true): string;
function RStrTrim(Source: string): string;
function AddTrailingSpaces(Len: integer): string;
function Append_YYYYMMDD(aStr : String; dt : TDateTime): string;
function Append_YYYYMMDDHHNN(aStr : String; dt : TDateTime): string;
function SqlLiteDate(const dt: tDatetime): string; // '2005-11-31'
function SqliteDateTime(const dt: tDatetime): string;
function SqliteEncodeDateTime(dtStr, tmStr : String) : TDateTime;
function SQLSingleQuote(const Value: string): string;
function SQLBracket(const Value: string): string;
function SQ(const Value: string): string;
function SQLStrEncode(const Value: string): string;
function StoB(Source: string; S: integer = -1): Boolean;
function StoI(Source: string; default : integer = 0): integer;
function StoByte(Source: string): Byte;
function S2I(Source: string; default : integer = 0): integer;
function StoR(Source: string): double;
function StrTooLong(Source: string; Len: byte): Boolean;  deprecated 'conflicted with TPStuff Str2Long conversion';
function StripToNumbers(aStr: string; AllowDecimal: Boolean = False): string;
function ExtractInt(const s: string; default: integer=0): integer;
function RemoveNumbers(aStr : String) : String;
function StripToAlphaNumeric(aStr: string): string;
function StripToPrintable(const aOriginalString: string;
  RemoveDoubleSpaces: Boolean = False): string;
function LowAsciiPrintable(const srcStr: string): Boolean;
function TruncStr(Source: string; Len: byte): string;
function TSet(const Source: string; const Len: integer): string;
function UnSimpleEncrypt(Source: string): string;
procedure PreProcess(var S: string; Delimiter, OnStr, OffStr: string);
procedure StoC(Source: string; var Dest; count: byte);
procedure StrReplace(FindStr, ReplStr: string; var S: string);
function StringIndex(const aStrg: string; aStrgs: array of string;
  aIgnoreCase: Boolean): integer;
function IsIn(const aStrg: string; aStrgs: array of string;
  aIgnoreCase: Boolean): Boolean;
function EscapeAmpersands(const S: string): string;

{ ComparePtr compare the address of two pointers.  It returns -1 if the
  address of P1 is lower than the address of P2, 0 if the address of P1 is
  equal to the address of P2, or 1 if the address of P1 is higher than P2. }
function ComparePtr(P1, P2: Pointer): longint;
// PtrDiff returns the number of bytes difference between P1 and P2
function PtrDiff(P1, P2: Pointer): longint;

// These functions are not string related and should be moved some day

function Bmp2Jpg(Bmp: TBitmap; Quality: integer = 100): TJpegImage;
function Jpg2Bmp(Jpg: TJpegImage): TBitmap;
procedure LoadJPGFromRes(aResName: string; Picture: TPicture);
procedure DisableAllControls(AControl: TWinControl);
procedure ReenableAllControls(AControl: TWinControl);
procedure UnpackPath(FileSpec: string; var Drive, PathPart, FileName,
  FileExt: string; FullFilename: Boolean = False);
function GetShortPath(Path: string; Count: Integer): string;
function ComponentToString(Component: TComponent): string;
function GetSystemType: TOpSysTypes;
function IsInvalidEmail(const S: string; AllowNA: Boolean = False): Boolean;
function CharList(aList: string): string;
function QuoteEscape(const Value: string; const QuoteChar: char = SINGLEQUOTE): string;
function QuotedList(const aList: string): string;
function ListNamesToDelim(aList: { TStrings; } TStringList;
  const QuoteChar: char = #0): string;
function ExtractFileNameWithoutExt(const FileName: string): string;
function FileVersion(FileName: string; var v1, v2, v3, v4: integer): string;
function FileVersionStr(FileName: string): string;
function ComputerName: string;
function getSubStrCharSeperated(LongString: string; SubSt: char;
  LocNum: integer): string;
procedure CalcCRC32(P: Pointer; ByteCount: DWORD; var CRCValue: DWORD);
procedure CalcFileCRC32(FromName: string; var CRCValue: DWORD;
  var TotalBytes: TInteger8; var error: word);

function FilesExist(StartDir, FileMask: string;subdirs: Boolean = True): Boolean;
procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string; subdirs: Boolean = True; olderThan: TDateTime = 0; newerThan: TDateTime = 0);
procedure DeleteOlderFiles(const Folder, FileMask: string; AgeInDays: integer; subDirs: boolean=false);
function FileBytesIdentical(const file1, file2: string): boolean;
procedure RemoveBOMHeader(const fname: string);
function PatchAsciiFilename(const fname: string; AllowPathCharacters: boolean): string;

function CharFromVirtualKey(Key: word): string;
function IAddrToHostName(const IP: Ansistring): Ansistring;
function StripCharSet(srcStr, StripStr: string): string;
function processExists(exeFileName: string): Boolean;
function MMDDYYYY(myDate: tDatetime): string;
function YYMMDD(myDate: tDatetime): string;
function HHMMSS(myTime: tDatetime): string;
function YearsAgo(numYears: integer): tDatetime;

// system
function SetFocusTo(ctrl: TControl): Boolean;
function ClearKeyboardBuffer: Boolean;
function GetGlobalOffline: Boolean;
procedure SetGlobalOffline(bOffline: Boolean);
function GetEnvVarValue(const VarName: string): string;
function SetEnvVarValue(const VarName, VarValue: string): integer;
// works, but not using now function ForegroundWindowTitle : String;
procedure ShellExecute_AndWait(FileName: string; Params: string;Wait: Boolean = True; NORMAL : boolean = true);
function WinExecAndWait32(FileName: string; Visibility: integer = SW_SHOWNORMAL)
  : Longword;
procedure PrintDocToDefaultPrinter(Handle: HWND; FileSpec: string);
function SaveStringToFile(S, FileNameStr: string; append : Boolean = false; prepend : Boolean = false): Boolean;
function LoadStringFromFile(FileNameStr: string; index : integer = -1): string;
procedure CopyFile(const FSrc, FDst: string);
function CaptureConsoleOutput(const ACommand, AParameters: String) : string;
function IsInFiftyStates(aStateStr: string): Boolean;
function CreateShortcut(Path, Description: string) : Boolean;
procedure EnableAWindow(winHandle: HWND; enableIt : boolean);
function TouchFile(filename: string; myDateTime : TDateTime): boolean;

// printer
function GetDefaultPrinter: string;
function SwitchToPrinter(vclPrinterName: String): integer;
function ShellSetDefaultPrinter(PrinterIndex: integer; Wait: Boolean = True): Boolean; overload;
function ShellSetDefaultPrinter(PrinterName: string; Wait: Boolean = True): Boolean; overload;
function GetSetDefaultPrinter(newPrinterName: string): string;
function Coalesce(Values: array of string): string;

// Delphi 2010 Compatibility
{$IFDEF VER150}
function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean;
{$ENDIF}

implementation

uses
  ShellAPI,
  Winsock,
  System.Character,
  StrUtils,
  Forms,
  TlHelp32,
  Messages,
  Registry,
  WinInet,
  Printers,
  // for CreateShortcut
  ShlObj, ActiveX, ComObj;


const
  hexChars: array [0 .. $F] of char = '0123456789ABCDEF';

var
  KEYBOARD_KEYS: array [0 .. 255] of string;

  // *** Pascal string functions ***

function Add_BackSlash(const S: string): string;
begin
  Result := S;
  if (Length(Result) > 0) and (Result[Length(Result)] <> '\') then
  // if last char isn't a backslash...
    Result := Result + '\'; // make it so
end;

function RemoveLeadingBackSlash(const S: string): string;
begin
  Result := S;
  if (Length(Result) > 0) and (Result[1] = '\') then
    delete(Result, 1,1);
end;

function RemoveBackSlash(const S: string): string;
begin
  Result := S;
  if (Length(Result) > 0) and (Result[Length(Result)] = '\') then
  // if last character is a backslash...
    DecStrLen(Result, 1); // decrement string length
end;

function AddForwardSlash(const S: string): string;
begin
  Result := S;
  if (Length(Result) > 0) and (Result[Length(Result)] <> '/') then
    Result := Result + '/';
end;

function RemoveForwardSlash(const S: string): string;
begin
  Result := S;
  if (Length(Result) > 0) and (Result[Length(Result)] = '/') then
    DecStrLen(Result, 1); // decrement string length
end;

procedure DecStrLen(var S: string; DecBy: integer);
begin
  SetLength(S, Length(S) - DecBy); // decrement string length by DecBy
end;

function GetCurLine(const S: string; Position: integer): string;
var
  ResP: PChar;
  ResLen: integer;
begin
  StrGetCurLine(PChar(S), PChar(longint(S) + Position - 1), Length(S),
    ResP, ResLen);
  SetString(Result, ResP, ResLen);
end;

function GetStrAllocSize(const S: string): longint;
var
  P: ^longint;
begin
  P := Pointer(S); // pointer to string structure
  dec(P, 3); // 12-byte negative offset
  Result := P^ and not $80000000 shr 1; // ignore bits 0 and 31
end;

function GetStrRefCount(const S: string): longint;
var
  P: ^longint;
begin
  P := Pointer(S); // pointer to string structure
  dec(P, 2); // 8-byte negative offset
  Result := P^;
end;

function KillChars(const S: string; A: array of AnsiChar;
  CaseSensitive: Boolean): string;
var
  CharSet: TSysCharSet;
  i, j: integer;
  count: integer;
  aChar: char;
begin
  CharSet := []; // empty character set
  for i := Low(A) to High(A) do
  begin
    Include(CharSet, Ansistring(A)[i]); // fill set with array items
    if not CaseSensitive then
    begin // if not case sensitive, then also
      // if A[i] in ['A'..'Z'] then
      if CharInSet(A[i], ['A' .. 'Z']) then
      begin
        j := Ord(A[i]);
        aChar := chr(j + 32);
        Include(CharSet, AnsiChar(aChar)) // include lower cased or
        // Include(CharSet, Chr(Ord(A[i]) + 32)) // include lower cased or
      end
      else if CharInSet(A[i], ['a' .. 'z']) then
      begin
        j := Ord(A[i]);
        aChar := chr(j - 32);
        Include(CharSet, AnsiChar(aChar)) // include lower cased or
        // Include(CharSet, Chr(Ord(A[i]) - 32)) // include upper cased character
      end
    end;
  end;
  SetLength(Result, Length(S)); // set length to prevent realloc
  count := 0;
  for i := 1 to Length(S) do
  begin // iterate over string S
    if not CharInSet(S[i], CharSet) then // (S[i] in CharSet) then
    begin // add good chars to Result
      Result[count + 1] := S[i];
      inc(count); // keep track of num chars copies
    end;
  end;
  SetLength(Result, count); // set length to num chars copied
end;

function LastPos(const SubStr, S: string): integer;
var
  FoundStr: PChar;
  L1 : Cardinal;
  L2 : Cardinal;
begin
  Result := 0;
  FoundStr := StrLastPos(PChar(S), PChar(SubStr));
  L1 := Length(S);
  L2 := StrLen(FoundStr);
  if FoundStr <> nil then
    Result := L1 - L2 + 1;
end;

procedure RealizeLength(var S: string);
begin
  SetLength(S, StrLen(PChar(S)));
end;

function RemoveSpaces(const S: string): string;
begin
  Result := KillChars(S, [' '], True);
end;

function RemoveControlCharacters(S: string): string;
var
  i: integer;
begin
  for i := 1 to Length(S) do
    if S[i] >= #20 then
      Result := Result + S[i];
end;

function ReverseStr(const S: string): string;
begin
  Result := S;
  StrReverse(PChar(Result));
end;

// *** PChar string functions ***

procedure StrGetCurLine(StartPos, CurPos: PChar; TotalLen: integer;
  var LineStart: PChar; var LineLen: integer);
var
  FloatPos, EndPos: PChar;
begin
  FloatPos := CurPos;
  LineStart := nil;
  repeat
    if FloatPos^ = LF then
    begin
      dec(FloatPos);
      if FloatPos^ = CR then
      begin
        inc(FloatPos, 2);
        LineStart := FloatPos;
      end;
    end
    else
      dec(FloatPos);
  until (FloatPos <= StartPos) or (LineStart <> nil);
  if LineStart = nil then
    LineStart := StartPos;
  FloatPos := CurPos;
  EndPos := StartPos;
  inc(EndPos, TotalLen - 1);
  LineLen := 0;
  repeat
    if FloatPos^ = CR then
    begin
      inc(FloatPos);
      if FloatPos^ = LF then
      begin
        dec(FloatPos, 2);
        LineLen := PtrDiff(FloatPos, LineStart);
        // integer(FloatPos) - integer(CurPos);
      end;
    end
    else
      inc(FloatPos);
  until (FloatPos >= EndPos) or (LineLen <> 0);
  if LineLen = 0 then
    LineLen := integer(EndPos) - integer(LineStart);
end;

// function StrIPos(Str1, Str2: PChar): PChar;
/// / Warning: this function is slow for long strings.
// begin
// Result := Str1;
// dec(Result);
// repeat
// inc(Result);
// Result := StrIScan(Result, Str2^);
// until (Result = nil) or (StrLIComp(Result, Str2, StrLen(Str2)) = 0);
// end;
//
// function StrIScan(Str: PChar; Chr: Char): PChar;
// asm
// push  edi                 // save edi
// push  eax                 // save eax (Str addr)
// mov   edi, Str            // store Str in edi
// mov   ecx, $FFFFFFFF      // max counter
// xor   al, al              // null char in al
// repne scasb               // search for null
// not   ecx                 // ecx = length of Str
// pop   edi                 // restore Str in edi
// mov   al, Chr             // put Chr in al
// cmp   al, 'a'             // if al is lowercase...
// jb    @@1
// cmp   al, 'z'
// ja    @@1
// sub   al, $20             // force al to uppercase
// @@1:
// mov   ah, byte ptr [EDI]  // put char from Str in ah
// cmp   ah, 'a'             // if al is lowercase...
// jb    @@2
// cmp   ah, 'z'
// ja    @@2
// sub   ah, $20             // force al to uppercase
// @@2:
// inc   edi                 // inc to next char in string
// cmp   al, ah              // are chars the same?
// je    @@3                 // jump if yes
// loop  @@1                 // loop if no
// mov   eax, 0              // if char is not in string...
// jne   @@4                 // go to end of proc
// @@3:                        // if char is in string...
// mov   eax, edi            // move char position into eax
// dec   eax                 // go back one character because of inc edi
// @@4:
// pop   edi                 // restore edi
// end;

function StrLastPos(Str1, Str2: PChar): PChar;
var
  Found: Boolean;
begin
  if (Str1 <> nil) and (Str2 <> nil) and (StrLen(Str1) >= StrLen(Str2)) then
  begin
    Found := False;
    Result := Str1;
    inc(Result, StrLen(Str1) - StrLen(Str2));
    repeat
      if StrPos(Result, Str2) <> nil then
        Found := True
      else
        dec(Result);
    until (Result <= Str1) or Found;
    if not Found then
      Result := nil;
  end
  else
    Result := nil;
end;

procedure StrReverse(P: PChar);
var
  E: PChar;
  C: char;
begin
  if StrLen(P) > 1 then
  begin
    E := P;
    inc(E, StrLen(P) - 1); // E -> last char in P
    repeat
      C := P^; // store beginning char in temp
      P^ := E^; // store end char in beginning
      E^ := C; // store temp char in end
      inc(P); // increment beginning
      dec(E); // decrement end
    until abs(PtrDiff(P, E)) <= 1;
  end;
end;

// --------------------string functions----------------------

function MinEndStr(const Source: string; MinPos: integer): integer;
var
  EndPos: integer;
begin
  EndPos := Length(Source);
  while (EndPos > 1) and (Source[EndPos] = ' ') do
    dec(EndPos);
  if (EndPos = 1) and (Source[EndPos] = ' ') then
    EndPos := 0;
  if EndPos < MinPos then
    MinEndStr := MinPos
  else
    MinEndStr := EndPos;
end;

function FmtStr(const Source, Mask: string; ExitPos: Boolean = False): string;
var
  EndEdit: integer;
  mpos, epos: integer;
begin
  Result := Mask;
  mpos := 1;
  epos := 1;
  EndEdit := MinEndStr(Source, 0);
  while mpos <= Length(Result) do
  begin
    if Result[mpos] = FieldChar then
    begin
      if epos <= EndEdit then
      begin
        Result[mpos] := Source[epos];
        inc(epos);
      end
      else
      begin
        if ExitPos then
          Result[mpos] := ' ';
      end;
    end;
    inc(mpos);
  end;
end;

function InStr(const SbSt: string; S: string; const Start: integer): integer;
begin
  Delete(S, 1, Start - 1);
  if (Pos(SbSt, S) > 0) then
    Result := Start - 1 + Pos(SbSt, S)
  else
    Result := 0;
end;

function Lset(const Source: string; const Len: integer): string;
begin
  Result := Copy(Source, 1, Len);
  Result := Result + AddTrailingSpaces(Len - Length(Result));
end;

function RSet(const Source: string; const Len: integer): string;
begin
  Result := Copy(Source, 1, Len);
  Result := AddTrailingSpaces(Len - Length(Result)) + Result;
end;

function TSet(const Source: string; const Len: integer): string;
begin
  if Len = 0 then
    Result := ''
  else
  begin
    if Length(Source) >= Len then
      Result := Copy(Source, 1, Len - 1) + #133
    else
      Result := Source + AddTrailingSpaces(Len - Length(Source));
  end;
end;

// count occurrences of a given substring
// original PosCount created many strings (wasteful)
// note that counting 'xx' from 'xxxx' yields 3 not 2 (like the original version)
function PosCount(const SubStr: string; S: string;
  CaseSensitive: Boolean = False): integer;
var
  ii: integer;
  ss: string;
  matchloc: integer;
begin
  Result := 0;
  ss := SubStr;
  if not CaseSensitive then
  begin
    ss := UpperCase(ss);
    S := UpperCase(S);
  end;
  ii := 1;
  matchloc := PosEx(substr, s, ii);
  while (matchloc > 0) do begin
    inc(result);
    matchloc := PosEx(substr, s, matchloc+1);
  end;
end;

function PosNum(const SubStr: string; S: string; FindPos: integer;
  CaseSensitive: Boolean = False): integer;
var
  i, j, C: integer;
  ss: string;
begin
  ss := SubStr;
  if not CaseSensitive then
  begin
    ss := UpperCase(ss);
    S := UpperCase(S);
  end;
  C := PosCount(ss, S);
  j := 0;
  if FindPos < -C then
    for i := 1 to FindPos do
      if (Copy(S, i, Length(ss)) = ss) then
        j := i;
  Result := j;
end;

function Contains(const SubStr: string; S: string; CaseSensitive: Boolean = False): Boolean;
var
  mySubStr, myString: string;
begin
  mySubStr := SubStr;
  myString := S;
  if not CaseSensitive then
  begin
    mySubStr := UpperCase(mySubStr);
    myString := UpperCase(myString);
  end;
  if Length(mySubStr) > 0 then
    Result := Pos(mySubStr, myString) > 0
  else
    Result := False;
end;

function Contains(const SubStr: string; S: string; var SubIndex: integer): Boolean;
begin
  if Length(SubStr) > 0 then
  begin
    SubIndex := Pos(UpperCase(SubStr), UpperCase(S));
    Result := SubIndex > 0;
  end
  else
    Result := False;
end;

function OnlyNumbers(Source: string): string;
var
  P: string;
  i: integer;
begin
  P := '';
  for i := 1 to Length(Source) do
    if CharInSet(Source[i], ['0' .. '9']) then
      P := P + Source[i];
  OnlyNumbers := P;
end;

function FillStr(const Source: string; Len: byte): string;
var
  P: PChar;
  C: Integer;
begin
  C := Length(Source);
  SetLength(Result, C * Len);
  P := Pointer(Result);
  if P = nil then Exit;
  while Len > 0 do
  begin
    Move(Pointer(Source)^, P^, C * SizeOf(Char));
    Inc(P, C);
    Dec(Len);
  end;
end;

function TruncStr(Source: string; Len: byte): string;
begin
  if Length(Source) > Len then
    Delete(Source, Succ(Len), Length(Source) - Len);
  TruncStr := Source;
end;

function LPad(Source: string; Len: byte; Filler: char = ' '): string;
begin
  Result := Source;
  while Length(Result) < Len do
    Result := Filler + Result;
end;

function RPad(Source: string; Len: byte; Filler: char = ' '): string;
begin
  Result := Source;
  while Length(Result) < Len do
    Result := Result + Filler;
end;

function PadChar(Source: string; Ch: char; Len: byte): string;
var
  CurrLen: byte;
begin
  if Length(Source) < Len then
    CurrLen := Length(Source)
  else
    CurrLen := Len;
  SetLength(Source, Len);
  FillChar(Source[Succ(CurrLen)], Len - CurrLen, Ch);
  PadChar := Source;
end;

function PadRight(Source: string; Ch: char; Len: byte): string;
var
  Temp: string;
begin
  Temp := Source;
  while (Length(Temp) < Len) do
    Temp := Temp + Ch;
  PadRight := Temp;
end;

function CenterStr(Source: string; Len: byte): string;
begin
  Source := LeftJustStr(LeftJustStr('', (Len - Length(Source)) shr 1) +
    Source, Len);
  CenterStr := Source;
end;

function LeftJustStr(Source: string; Len: byte): string;
begin
  LeftJustStr := PadChar(Source, ' ', Len);
end;

function RightJustStr(Source: string; Len: byte): string;
begin
  Source := TruncStr(Source, Len);
  RightJustStr := LeftJustStr('', Len - Length(Source)) + Source;
end;

function FirstWord(Source: string): string;
var
  x: byte;
begin
  x := 0;
  while (x < Length(Source)) and
    (CharInSet(Source[x + 1], ['A' .. 'Z', 'a' .. 'z', '0' .. '9'])) do
    inc(x);
  FirstWord := Copy(Source, 1, x);
end;

function LastWord(Source: string): string;
var
  x: byte;
begin
  x := Length(Source);
  while (x > 1) and (CharInSet(Source[x - 1], ['A' .. 'Z', 'a' .. 'z',
    '0' .. '9'])) do
    dec(x);
  LastWord := Copy(Source, x, 255);
end;

function StrTooLong(Source: string; Len: byte): Boolean;
begin
  Result := Length(Source) > Len;
end;

function StripToNumbers(aStr: string; AllowDecimal: Boolean = False): string;
var
  C: char;
{$IFDEF VER150}
  i : integer;
{$ENDIF}
begin
  Result := '';
  {$IFDEF VER150}
  for i := 1 to length(AStr) do begin
    c := AStr[i];
  {$ELSE}
  for C in aStr do begin
  {$ENDIF}
    if not AllowDecimal then
    begin
      if CharInSet(C, ['-', '0' .. '9']) then
        if (Length(Result) <> 0) and (C = '-') then
        else
          Result := Result + C;
    end
    else
    begin
      if CharInSet(C, ['-', '.', '0' .. '9']) then
        if (Length(Result) <> 0) and (C = '-') then
        else
          Result := Result + C;
    end;
  end;
end;

// ExtractInt allows leading or trailing stuff on a string. Ignores embedded commas
// but only allows an optional leading +/- sign, followed by a string of digits
// anything else terminates the integer value within the string.
// Examples:
// ' 12 Joe ' => '12'
// ' 12 Joe 34' => '12'
// ' x 12 y' => '12'
// 'x-5y' => '-5'
// '- 5y' => default, space terminates the numeric string, '-' is not a valid integer
// '--5y' => default, the second minus terminates the numeric string, '-' is not a valid integer
// '0x14' => '0' -- x terminates the integer
// '$14' => '14' -- the leading $ is ginored
// '12,345' => '12345'
// '12,3,4,5' => '12345' -- all commas ignored, not just the ones that would be valid US formtting
// '12.345' => '12' -- period terminates the integer

function ExtractInt(const s: string; default: integer=0): integer;
var
  i: integer;
  ss: string;
begin
  result := default;
  ss := '';
  for i := 1 to length(s) do begin
    if (ss = '') and ((s[i] = '-') or (s[i] = '+')) then
      ss := ss + s[i]
    else if IsDigit(s[i]) then
      ss := ss + s[i]
    else if s[i] = ',' then
      // ignore commas
    else if ss <> '' then
      break;
  end;
  if TryStrToInt(ss, i) then
    result := i;
end;

function RemoveNumbers(aStr : String) : String;
var aChar : Char;
begin
  Result := '';
  for aChar in aStr do
    if not CharInSet(aChar, ['0'..'9']) then
      Result := Result + aChar;
end;

function StripToAlphaNumeric(aStr: string): string;
var // removes extra spaces, CR, LF, TABs.  Preserves dblspc for colons and periods.
  C: char;
{$IFDEF VER150}
  i : integer;
{$ENDIF}
begin
  Result := '';
  {$IFDEF VER150}
  for i := 1 to length(AStr) do begin
    c := AStr[i];
  {$ELSE}
  for C in aStr do begin
  {$ENDIF}
    if CharInSet(C, ['0' .. '9', 'a' .. 'z', 'A' .. 'Z']) then
      Result := Result + C;
  end;
end;

function LowAsciiPrintable(const srcStr: string): Boolean;
var
  C: char;
{$IFDEF VER150}
  i : integer;
{$ENDIF}

begin
  Result := true;
  {$IFDEF VER150}
  for i := 1 to length(srcStr) do begin
    c := srcStr[i];
  {$ELSE}
  for C in srcStr do begin
  {$ENDIF}
    if not CharInSet(C, [#32 .. #127]) then
      Result := False;
  end;
end;

function StripToPrintable(const aOriginalString: string;
  RemoveDoubleSpaces: Boolean = False): string;
var
  C: char;
{$IFDEF VER150}
  i : integer;
{$ENDIF}
begin
  Result := '';
  {$IFDEF VER150}
  for i := 1 to length(aOriginalString) do begin
    c := aOriginalString[i];
  {$ELSE}
  for C in aOriginalString do begin
  {$ENDIF}
    if (C >= #32) then
      Result := Result + C;
  end;
  if RemoveDoubleSpaces then
    Result := ReplaceString(Result, '  ', ' ');
end;

function LStrTrim(Source: string): string;
begin
  while (Length(Source) > 0) and (Source[1] = #32) and (Length(Source) > 0) do
    Delete(Source, 1, 1);
  Result := Source;
end;

function RStrTrim(Source: string): string;
begin
  while (Length(Source) > 0) and CharInSet(Source[Length(Source)], [#32, #0]) do
    SetLength(Source, Length(Source) - 1);
  Result := Source;
end;

function StringIsQuoted(aStr: string; dblQuote : boolean = true): Boolean;
var qStr : string;
begin
  if dblQuote then
    qStr := doubleQuote
  else
    qStr := singleQuote;

  Result := (aStr[1] = qStr) and (aStr[length(aStr)] = qStr);
end;

function RemoveQuotes(aStr: string; dblQuote : boolean = true): string;
var qStr : string;
begin
  if dblQuote then
    qStr := doubleQuote
  else
    qStr := singleQuote;

  if aStr[1] = qStr then
    delete(aStr, 1, 1);
  if aStr[1] = qStr then
    delete(aStr, length(aStr), 1);
  Result := aStr;
end;

function AddTrailingSpaces(Len: integer): string;
begin
  Result := '';
  while Length(Result) < Len do
    Result := Result + char(32); // #32;
end;

procedure PreProcess(var S: string; Delimiter, OnStr, OffStr: string);
var
  CodeOn: Boolean;
  CurrPos: integer;
begin
  CodeOn := False;
  repeat
    CurrPos := Pos(Delimiter, S);
    if CurrPos <> 0 then
    begin
      Delete(S, CurrPos, Length(Delimiter));
      if CodeOn then
        Insert(OffStr, S, CurrPos)
      else
        Insert(OnStr, S, CurrPos);
      CodeOn := not CodeOn;
    end;
  until (CurrPos = 0);
  if CodeOn then
    S := S + OffStr;
end;

procedure StrReplace(FindStr, ReplStr: string; var S: string);
begin
  S := StringReplace(S, FindStr, ReplStr, [rfReplaceAll]);
end;

function ReplaceString(const Source, FindStr, ReplStr: string): string;
begin
  Result := StringReplace(Source, FindStr, ReplStr, [rfReplaceAll]);
end;

function ReplaceChar(FindChar, NewChar: char; SourceStr: string): string;
var
  i: integer;
begin
  for i := 1 to Length(SourceStr) do
    if SourceStr[i] = FindChar then
      SourceStr[i] := NewChar;
  Result := SourceStr;
end;

function FirstChar(const aStr: String): string;
begin
  if length(aStr) > 0 then
    Result := aStr[1]
  else
    Result := '';
end;

function LastChar(const aStr: String): string;
begin
  Result := copy(aStr, length(aStr), 1);
end;

function RemoveLastChar(const LastChar: string; const SourceStr: string): string;
begin
  if lastChar > '' then
    Result := RemoveLastChar(lastChar[1], SourceStr)
  else
    Result := SourceStr;
end;

function RemoveLastChar(const LastChar: char; const SourceStr: string): string;
var
  CurLen: integer;
begin
  Result := SourceStr;
  CurLen := Length(Result);
  if (CurLen > 0) and (Result[CurLen] = LastChar) then
    SetLength(Result, CurLen - 1);
end;

function BtoH(Source: byte): string;
begin
  BtoH := hexChars[Source shr 4] + hexChars[Source and $F];
end;

function BtoI(b: Boolean): integer;
begin
  if b then
    Result := 1
  else
    Result := 0;
end;

function ItoB(i: Integer): boolean;
begin
  Result := (i > 0);
end;

function Hex2Integer(const S: string): integer;
var
  bCtr: byte;
  sTmp: string;
begin
  sTmp := LStrTrim(RStrTrim(S));
  // Remove any leading, trailing, or embedded spaces
  for bCtr := 1 to Length(sTmp) do
  begin // Make sure valid hex digits passed
    if not CharInSet(sTmp[bCtr], ['$', '0' .. '9', 'A' .. 'F', 'a' .. 'f']) then
    begin
      Result := 0;
      exit;
    end;
  end;
  if sTmp[1] <> '$' then
  // See if hex indicator (dollar sign) is first character...
    sTmp := '$' + sTmp;
  Result := StoI(sTmp); // Finally done...
end;

function ItoH(Source: SmallInt): string;
begin
  ItoH := BtoH((Source and $FF00) shr 8) + BtoH(Source and $FF);
end;

function LtoH(Source: longint): string;
begin
  LtoH := ItoH((Source and $FFFF0000) shr 16) + ItoH(Source and $FFFF);
end;

function S2I(Source: string; default : integer = 0): integer;
begin
  try
    Result := StrToInt(Source);
  except
    Result := default;
  end;
end;

function StoI(Source: string; default : integer = 0): integer;
var
  TInt: integer;
  E: integer;
begin
  Source := Trim(Source);
  Val(Source, TInt, E);
  if E = 0 then
    Result := TInt
  else
    Result := default;
end;

function StoByte(Source: string): byte;
var
  TBite: byte;
  E: integer;
begin
  Source := Trim(Source);
  Val(Source, TBite, E);
  if E = 0 then
    Result := TBite
  else
    Result := 0;
end;

function StoR(Source: string): double;
var
  aDouble: double;
  E: integer;
begin
  Source := RStrTrim(Source);
  Source := LStrTrim(Source);
  if Length(Source) > 0 then
  begin
    Val(Source, aDouble, E);
    if E = 0 then
      Result := aDouble
    else
      Result := 0.0;
  end
  else
    Result := 0.0;
end;

function RtoR(Source: double; d: integer): double;
var
  Temp: string;
begin
  Temp := RtoS(Source, 13, d);
  RtoR := StoR(Temp);
end;

procedure StoC(Source: string; var Dest; count: byte);
begin
  if Length(Source) < count then
  begin
    FillChar(Dest, count, #32);
    Move(Source[1], Dest, Length(Source));
  end
  else
    Move(Source[1], Dest, count);
end;

function I2S(S: integer): string; overload;
begin
  try
    Result := IntToStr(S);
  except
    Result := '0';
  end;
end;

function ItoS(S: integer): string; //overload;
begin
  Result := I2S(S);
end;

function ItoS(Source: integer; S: integer): string; overload;
var
  aStr: Ansistring;
begin
  if ZeroSupress and (Source = 0) then
    Result := AddTrailingSpaces(S)
  else
  begin
    Str(Source: S, aStr);
    Result := String(aStr);
  end;
end;

function StoIS(Source: string): string;
begin
  Result := ItoS(StoI(Source));
end;

function ItoF(Source: longint; S: integer; Fmt: string): string;
var
  TStr: string;
  aStr: Ansistring;
begin
  Str(Source: S, aStr);
  TStr := string(aStr);
  if (Pos('Z', Fmt) <> 0) and (Source = 0) then
    TStr := AddTrailingSpaces(S);
  ItoF := TStr;
end;

function RtoS(Source: double; S, d: integer): string;
var
  TStr: string;
  aStr: Ansistring;
begin
  Str(Source: S: d, aStr);
  TStr := String(aStr);
  RtoS := TStr;
end;

function RtoD(Source: double; S, d: integer): string;
var
  TStr: string;
  SPos: integer;
var
  aStr: Ansistring;
begin
  Str(Source: 0: d, aStr);
  TStr := String(aStr);
  if Pos('.', TStr) > 0 then
  begin
    SPos := Pos('.', TStr) - 3;
  end
  else
    SPos := Length(TStr) - 2;
  while (SPos > 1) do
  begin
    Insert(',', TStr, SPos);
    SPos := SPos - 3;
  end;
  if ZeroSupress and (Source = 0) then
    TStr := AddTrailingSpaces(S);
  RtoD := RSet(TStr, S);
end;

function RtoF(Source: double; S, d: integer; Fmt: string): string;
var
  TStr: string;
  x: integer;
  aStr: Ansistring;
  // r                      : Real;
begin
  // r := Source;
  if (Pos('Z', Fmt) <> 0) and (Source = 0.0) then
    RtoF := AddTrailingSpaces(S)
  else
  begin
    // Str(Source: S: D, TStr);
    Str(Source, aStr);
    TStr := String(aStr);
    if (d > 0) and (Pos('P', Fmt) <> 0) then
    begin
      x := Length(TStr);
      while TStr[x] = '0' do
      begin
        TStr[x] := ' ';
        dec(x);
      end;
      if TStr[x] = '.' then
        TStr[x] := ' ';
    end;
    RtoF := TStr;
  end;
end;

function StoB(Source: string; S: integer): Boolean;
begin
  Source := UpperCase(Source);
  case S of
    - 1:
      Result := (Source = 'Y') or (Source = 'YES') or (Source = 'TRUE') or
        (Source = 'ON') or (Source = 'NEW');
    1:
      Result := (Source = 'Y');
    2:
      Result := (Source = 'YES');
    3:
      Result := (Source = 'TRUE');
    4:
      Result := (Source = 'ON');
    5:
      Result := (Source = 'NEW')
  else
    Result := False;
  end;
end;

function BtoS(Source: Boolean; S: integer): string;
begin
  if Source then
    case S of
      1:
        BtoS := 'Y';
      2:
        BtoS := 'YES';
      3:
        BtoS := 'TRUE';
      4:
        BtoS := 'ON';
      5:
        BtoS := 'NEW';
      6:
        BtoS := 'NEW';
    end
  else
    case S of
      1:
        BtoS := 'N';
      2:
        BtoS := 'NO';
      3:
        BtoS := 'FALSE';
      4:
        BtoS := 'OFF';
      5:
        BtoS := 'USED';
      6:
        BtoS := 'UPGRADE';
    end;
end;

function EndStr(Source: string): byte; // find end of a string
var
  EndPos: byte;
begin
  EndPos := Length(Source);
  while (EndPos > 1) and ((Source[EndPos] = ' ') or (Source[EndPos] = #0)) do
    dec(EndPos);
  if (EndPos = 1) and (Source[EndPos] = ' ') then
    EndStr := 0
  else
    EndStr := EndPos;
end;

function All_Numeric(Source: string): Boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to Length(Source) do
  begin
    if (i = 1) and CharInSet(Source[i], ['-', '0' .. '9']) then
      Result := True
    else if Result then
      Result := CharInSet(Source[i], ['0' .. '9']);
  end;
end;

function AllNumericOrX(Source: string): Boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to Length(Source) do
  begin
    if (i = 1) and CharInSet(Source[i], ['-', '0' .. '9', 'X']) then
      Result := True
    else if Result then
      Result := CharInSet(Source[i], ['0' .. '9', 'X']);
  end;
end;

function AllUnsignedNumeric(Source: string): Boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to Length(Source) do
  begin
    if Result then
      Result := CharInSet(Source[i], ['0' .. '9']);
  end;
end;

function IsInteger(Source: string): Boolean;
begin
  Result := (ItoS(StoI(Source)) = Source);
end;

function IsNumber(Source: string; var Num: integer): Boolean;
var
  i, Ecode: integer;
  Valid: Boolean;
begin
  Valid := True;
  for i := 1 to Length(Source) do
    if (Source[i] < '0') or (Source[i] > '9') then
      Valid := False;

  if Valid then
  begin
    Val(Source, Num, Ecode);
    if Ecode <> 0 then
      Num := 0;
    IsNumber := True;
  end
  else
    IsNumber := False;
end;

function IsFloatStr(Source: string; var Num: double): Boolean;
var
  i, Ecode: integer;
begin
  Result := True;
  Ecode := 0;
  for i := 1 to Length(Source) do
  begin
    if Source[i] = '.' then
      inc(Ecode);
    if not CharInSet(Source[i], ['0' .. '9', '.']) then
      Result := False;
  end;

  if Result then // Ensure there is no more than one decimal point
    Result := (Ecode < 2) // and that it is not the 1st or last character
      and (((Source[1] = '.') and (Source[Length(Source)] > '.')) or
      (Source[1] <> '.'));

  if Result then
  begin
    Val(Source, Num, Ecode);
    if Ecode <> 0 then
      Num := 0;
  end;
end;

function SimpleEncrypt(Source: string): string;
var
  i, j: SmallInt;
begin
  Result := '';
  for i := 1 to Length(Source) do
  begin
    j := Ord(Source[i]);
    j := j + (71 + 3 * i);
    Result := Result + chr(j);
  end;
end;

function UnSimpleEncrypt(Source: string): string;
var
  i, j: SmallInt;
begin
  Result := '';
  for i := 1 to Length(Source) do
  begin
    j := Ord(Source[i]);
    j := j - (71 + 3 * i);
    Result := Result + chr(j);
  end;
end;

function CheckSum(Source: string): longint;
var
  i, T: longint;
begin
  T := 0;
  for i := 1 to Length(Source) do
    T := T + Ord(Source[i]);
  CheckSum := T;
end;

function InCommandLine(Source: string): Boolean;
var
  i: integer;
begin
  Source := UpperCase(Source);
  InCommandLine := False;
  i := ParamCount;
  while i > 0 do
  begin
    if Pos(Source, UpperCase(ParamStr(i))) > 0 then
    begin
      InCommandLine := True;
      i := 0;
    end;
    dec(i);
  end;
end;

function CodeToAscii(Code: Ansistring; Offset: byte): Ansistring;
var
  i, j: integer;
  S: Ansistring;
begin
  S := '';
  for i := 1 to Length(Code) do
  begin
    if (i = Offset) then
      S := S + '<##>';
    case Code[i] of
      #27:
        S := S + '<esc>';
      #0 .. #26, #28 .. #32, #128 .. #255:
        begin
          j := Ord(Code[i]);
          S := '<#' + Ansistring(ItoS(j)) + '>';
        end;
      // S := S + '<#' +
      // ItoS(Ord(Code[i]), 1) + '>';
    else
      S := S + Code[i];
    end;
  end;
  CodeToAscii := S;
end;

function NotZero(NumStr: string): Boolean;
begin
  Result := NotZero(StoI(NumStr));
end;

function NotZero(NumInt: integer): Boolean; overload;
begin
  Result := (NumInt <> 0);
end;

function IsZero(NumStr: string): Boolean;
begin
  Result := IsZero(StoI(NumStr));
end;

function IsZero(NumInt: integer): Boolean; overload;
begin
  Result := (NumInt = 0);
end;

function AsChar(AString: string): char;
begin
  if Length(AString) > 0 then
    Result := AString[1]
  else
    Result := #0;
end;

function AsWord(aInt: integer): word;
var
  i: SmallInt;
begin
  i := aInt;
  Result := word(i);
end;

function HTTPEncode2(const aStr: string): string;
const
  NoConversion = ['A' .. 'Z', 'a' .. 'z', '*', '@', '.', '_', '-', '0' .. '9',
    '$', '!', '''', '(', ')', '/', '|'];
var
  Sp, Rp: PChar;
begin
  SetLength(Result, Length(aStr) * 3);
  Sp := PChar(aStr);
  Rp := PChar(Result);
  while Sp^ <> #0 do
  begin
    if CharInSet(Sp^, NoConversion) then // Sp^ in NoConversion then
      Rp^ := Sp^
    else
    begin
      FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
      inc(Rp, 2);
    end;
    inc(Rp);
    inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function HTTPEncode1(const aStr: string): string;
const
  NoConversion: set of AnsiChar = ['A' .. 'Z', 'a' .. 'z', '*', '@', '.', '_',
    '-', '|'];
  // NoConversion  : set of char = ['A'..'Z', 'a'..'z', '*', '@', '.', '_', '-'];
var
  Sp, Rp: PChar;
begin
  SetLength(Result, Length(aStr) * 3);
  Sp := PChar(aStr);
  Rp := PChar(Result);

  while Sp^ <> #0 do
  begin
    if CharInSet(Sp^, NoConversion) then
      // if Sp^ in NoConversion then
      Rp^ := Sp^
    else if Sp^ = ' ' then
      Rp^ := '+'
    else
    begin
      FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
      inc(Rp, 2);
    end;
    inc(Rp);
    inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function LongDateTimeStrToDateTime(aLongStr: string): tDatetime;
// 2011-04-06T13:25:18-04:00
var
  y, m, d, th, tm, ts: word;
  aStr: string;
  dt: tDatetime;
begin // 2011-04-06T13:25:18-04:00
  aStr := aLongStr;
  Result := 0;
  if Length(aStr) >= 19 then
  begin
    y := StoI(Copy(aStr, 1, 4));
    m := StoI(Copy(aStr, 6, 2));
    d := StoI(Copy(aStr, 9, 2));
    th := StoI(Copy(aStr, 12, 2));
    tm := StoI(Copy(aStr, 15, 2));
    ts := StoI(Copy(aStr, 18, 2));
    dt := EncodeDate(y, m, d) + EncodeTime(th, tm, ts, 0);
    if dt = 54 then
      dt := 53;
    Result := dt;
  end;
end;

function LZeroFill(aStr: string; Len: integer): string;
begin
  Result := aStr;
  while (Length(Result) < Len) do
    Result := '0' + Result;
end;

function DateTimeToLongDateTimeStr(aDate: tDatetime): string;
// 2011-04-06T13:25:18
var
  y, m, d, th, tm, ts, tms: word;
  sy, sm, sd, sth, stm, sts: string;
  // , stms : String;
  aStr: string;
begin // 2011-04-06T13:25:18
  DecodeDate(aDate, y, m, d);
  DecodeTime(aDate, th, tm, ts, tms);
  sy := LZeroFill(ItoS(y), 4);
  sm := LZeroFill(ItoS(m), 2);
  sd := LZeroFill(ItoS(d), 2);

  sth := LZeroFill(ItoS(th), 2);
  stm := LZeroFill(ItoS(tm), 2);
  sts := LZeroFill(ItoS(ts), 2);
  // stms:= LZeroFill(ItoS(tms),2);

  // AStr := '%s-%s-%sT%s:%s:%s:%s';
  // Result := Format(AStr, [sy,sm,sd, sth,stm,sts,stms]);
  aStr := '%s-%s-%sT%s:%s:%s';
  Result := Format(aStr, [sy, sm, sd, sth, stm, sts]);
end;

function ListGetItemByIndex(List: String; const idx: integer;
  const delimeter: string = ','): string;
var
  slist: TStringList;
begin
  Result := '';
  slist := TStringList.Create;
  try
{$IFDEF VER150}
{$ELSE}
    slist.StrictDelimiter := True;
{$ENDIF}
    slist.Delimiter := delimeter[1];
    slist.DelimitedText := List;
    if slist.count >= idx then
      Result := slist[idx];
  finally
    slist.Free;
  end;
end;

function ListItemCount(List: String; const delimeter: string = ','): integer;
var
  slist: TStringList;
begin
  Result := -1;
  slist := TStringList.Create;
  try
    slist.StrictDelimiter := True;
    slist.Delimiter := delimeter[1];
    slist.DelimitedText := List;
    Result := slist.Count;
  finally
    slist.Free;
  end;
end;

function ListGetIndexByItem(List: String; const item : String; const delimeter: string = ','): integer;
var
  slist: TStringList;
begin
  slist := TStringList.Create;
  try
{$IFDEF VER150}
{$ELSE}
    slist.StrictDelimiter := True;
{$ENDIF}
    slist.Delimiter := delimeter[1];
    slist.DelimitedText := List;
    Result := slist.IndexOf(item);
  finally
    slist.Free;
  end;
end;

function ListSetItemAtIndex(var List: String; const newItem: string;
  const idx: integer; const delimeter: string = ','): Boolean;
var
  slist: TStringList;
begin
  Result := False;
  slist := TStringList.Create;
  try
{$IFDEF VER150}
{$ELSE}
    slist.StrictDelimiter := True;
{$ENDIF}
    slist.Delimiter := delimeter[1];
    slist.DelimitedText := List;
    if slist.count >= idx then
    begin
      slist.Insert(idx, newItem);
      List := slist.Text;
      Result := True;
    end;
  finally
    slist.Free;
  end;
end;

function ListGetAt(List: string; const Position: integer; const Delimiter: string = ','): string;
var
  i, NP, DL: integer;
begin
  NP := 1;
  DL := Length(Delimiter);
  for i := 1 to Position do
  begin
    List := Copy(List, NP, Length(List) - NP + 1);
    NP := Pos(Delimiter, List) + DL;
    if i = Position then
    begin
      if Pos(Delimiter, List) = 0 then
        Break;
      Delete(List, NP - DL, Length(List) - (NP - DL - 1));
    end
    else if NP = DL then
    begin // No delimeter found and Position not yet reached.
      List := '';
      Break;
    end;
  end;
  Result := List;
end;

function ListSetAt(List: string; const Position: integer; const Value: string;
  const Delimiter: string = ','): string;
var
  i, NP, DL: integer;
  BegStr, EndStr: string;
begin
  NP := 1;
  DL := Length(Delimiter);
  BegStr := '';
  EndStr := '';
  for i := 1 to Position do
  begin
    if i > 1 then
      BegStr := BegStr + Copy(List, 1, Pos(Delimiter, List) + DL - 1);
    List := Copy(List, NP, Length(List) - NP + DL);
    NP := Pos(Delimiter, List) + DL;
    if (NP = DL) and (i < Position) then
    begin
      List := List + Delimiter;
      NP := Pos(Delimiter, List) + DL;
    end;
    if i = Position then
    begin
      if Pos(Delimiter, List) = 0 then
        Break;
      EndStr := Copy(List, NP - DL, Length(List) - (NP - DL - 1));
    end;
  end;
  Result := BegStr + Value + EndStr;
end;

function ListLen(List: string; const Delimiter: string = ','): integer;
var
  DL: integer;
begin
  DL := Length(Delimiter);
  Result := Ord(List > ''); // Len = 0 if blank, 1 item if not blank
  while Pos(Delimiter, List) > 0 do
  begin
    Delete(List, 1, Pos(Delimiter, List) + DL - 1);
    inc(Result);
  end;
end;

function ListToDelim(const List: string; Delimiter: string): string;
begin
  Result := List;
  StrReplace(#13#10, Delimiter, Result);
  if Copy(Result, Length(Result) - (Length(Delimiter) - 1), Length(Delimiter)) = Delimiter
  then
    SetLength(Result, Length(Result) - Length(Delimiter));
  Result := RStrTrim(Result);
end;

function AddDelim(const List, Value: string; Delimiter: string = ',')
  : string; overload;
begin
  Result := List + IfThen(List > '', Delimiter) + Value;
end;

function AddDelim(const List: string; const Value: integer;
  Delimiter: string = ','): string; overload;
begin
  Result := List + IfThen(List > '', Delimiter) + ItoS(Value);
end;

function AddDelim(const List: string; const Value: double;
  Delimiter: string = ','): string; overload;
begin
  Result := List + IfThen(List > '', Delimiter) + FloatToStr(Value);
end;

function ComparePtr(P1, P2: Pointer): longint;
asm
  cmp eax, edx
  jge @@1
  mov eax, -1
  jmp @@3
@@1:
  cmp eax, edx
  jg @@2
  mov eax, 0
  jmp @@3
@@2:
  mov eax, 1
@@3:
end;

function PtrDiff(P1, P2: Pointer): longint;
asm
  sub eax, edx
end;

function Bmp2Jpg(Bmp: TBitmap; Quality: integer = 100): TJpegImage;
begin
  Result := nil;
  if Assigned(Bmp) then
  begin
    Result := TJpegImage.Create;
    Result.Assign(Bmp); // That's all folks...
    Result.CompressionQuality := Quality;
    Result.JPEGNeeded; // Key method...
    Result.Compress;
  end;
end;

function Jpg2Bmp(Jpg: TJpegImage): TBitmap;
begin
  Result := nil;
  if Assigned(Jpg) then
  begin
    Result := TBitmap.Create;
    Jpg.DIBNeeded; // Key method...
    Result.Assign(Jpg); // That's all folks...
  end;
end;

procedure LoadJPGFromRes(aResName: string; Picture: TPicture);
var
  Stream: TResourceStream;
  MyJPG: TJpegImage;
begin
  MyJPG := TJpegImage.Create;
  try
    try
      Stream := TResourceStream.Create(HInstance, aResName, 'JPG');
      try
        try
          MyJPG.LoadFromStream(Stream);
        except
        end;
      finally
        Stream.Free;
      end;
    except
    end;
    Picture.Assign(MyJPG);
  finally
    MyJPG.Free;
  end;
end;

function Between(const Value, ValLow, ValHigh: integer;
  AllowBlank: Boolean = True): Boolean; overload;
begin
  Result := (AllowBlank or ((Value <> 0) and (ValHigh <> 0))) and
    (Value >= ValLow) and (Value <= ValHigh);
end;

function Between(const Value, ValLow, ValHigh: double;
  AllowBlank: Boolean = True): Boolean; overload;
begin
  Result := (AllowBlank or ((Value <> 0) and (ValHigh <> 0))) and
    (Value >= ValLow) and (Value <= ValHigh);
end;

function Between(const Value, ValLow, ValHigh: string;
  AllowBlank: Boolean = True): Boolean; overload;
begin
  Result := (AllowBlank or ((Value <> '') and (ValHigh <> ''))) and
    (Value >= ValLow) and (Value <= ValHigh);
end;

function IIfThen(Xpression: Boolean; const Result1: string;
  const Result2: string = ''): string; overload;
begin
  if Xpression then
    Result := Result1
  else
    Result := Result2;
end;

function IIfThen(Xpression: Boolean; const Result1: integer;
  const Result2: integer = 0): integer; overload;
begin
  if Xpression then
    Result := Result1
  else
    Result := Result2;
end;

function IIfThen(Xpression: Boolean; const Result1: double;
  const Result2: double = 0): double; overload;
begin
  if Xpression then
    Result := Result1
  else
    Result := Result2;
end;

function FmtLongZuluDateString(aStr: string): String;
begin                // returns "2015/12/29 at 15:05:28"
  if length(aStr) <> 17 then begin
    Result := '';
    exit;
  end;

  Result :=          //20151229T15:05:28
    copy(aStr,1,4) + '/' + //  2015/
    copy(aStr,5,2) + '/' + //  2015/12/
    copy(aStr,7,2) +       //  2015/12/29
    ' at ' +
    RightStr(aStr,8);
end;

function FmtDateTime(const Format: string; DateTime: tDatetime): string;
begin
  try
    Result := FormatDateTime(Format, DateTime);
  except
    Result := '';
  end;
end;

function FmtDateTimeHMSZ(DateTime: tDatetime): string;
begin
  Result := FormatDateTime('hh:nn:ss:zzz', DateTime);
end;

function FmtDateTimeSqlLite(dt: TDateTime): string;
var
  yy, mm, dd, hh, nn, ss, ii: word;
begin
  DecodeDateTime(dt, yy, mm, dd, hh, nn, ss, ii);
  Result := LPad(ItoS(yy), 4, '0') + '-' + LPad(ItoS(mm), 2, '0') + '-' + LPad(ItoS(dd), 2, '0') + ' ' + LPad(ItoS(hh), 2, '0') + ':' + LPad(ItoS(nn), 2, '0') + ':' + LPad(ItoS(ss), 2, '0');
end;

function FmtDateSqlLite(dt: TDateTime): string;
var
  yy, mm, dd, hh, nn, ss, ii: word;
begin
  DecodeDateTime(dt, yy, mm, dd, hh, nn, ss, ii);
  Result := LPad(ItoS(yy), 4, '0') + '-' + LPad(ItoS(mm), 2, '0') + '-' + LPad(ItoS(dd),2,'0');
end;

function FmtTwoDecimalPlaces(d: double): string; overload;
begin
  Result := FormatFloat('#.00', d);
end;

function FmtTwoDecimalPlaces(S: string): string; overload;
begin
  Result := FmtTwoDecimalPlaces(StoR(S));
end;

{ TObjStringList }

procedure TObjStringList.Clear;
var
  Index: integer;
begin
  for Index := count - 1 downto 0 do
    Delete(Index);
  inherited;
end;

procedure TObjStringList.Delete(Index: integer);
begin
  if (Index >= 0) and (Index < count) and Assigned(Objects[Index]) then
    try
      Objects[Index].Free;
      Objects[Index] := nil;
    except
    end;
  inherited;
end;

destructor TObjStringList.Destroy;
begin
  Clear;
  inherited;
end;

{ TObjList }

procedure TObjList.Clear;
var
  Index: integer;
begin
  for Index := count - 1 downto 0 do
    Delete(Index);
  inherited;
end;

procedure TObjList.Delete(Index: integer);
begin
  if (Index >= 0) and (Index < count) and Assigned(Items[Index]) then
    try
      TObject(Items[Index]).Free;
      Items[Index] := nil;
    except
    end;
  inherited;
end;

destructor TObjList.Destroy;
begin
  Clear;
  inherited;
end;

procedure DisableAllControls(AControl: TWinControl);
var
  i: integer;
begin
  with AControl do
  begin
    for i := 0 to ControlCount - 1 do
    begin
      if Controls[i].Enabled then
      begin
        Controls[i].Enabled := False;
        Controls[i].Tag := 1;
      end;
      if Controls[i] is TWinControl then
        DisableAllControls(TWinControl(Controls[i]));
    end;
  end;
end;

procedure ReenableAllControls(AControl: TWinControl);
var
  i: integer;
begin
  with AControl do
  begin
    for i := 0 to ControlCount - 1 do
    begin
      if (Controls[i].Tag = 1) then
      begin
        Controls[i].Enabled := True;
        Controls[i].Tag := 0;
      end;
      if Controls[i] is TWinControl then
        ReenableAllControls(TWinControl(Controls[i]));
    end;
  end;
end;

function ComponentToString(Component: TComponent): string;
var
  BinStream: TMemoryStream;
  StrStream: TStringStream;
  S: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(S);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result := StrStream.DataString;
    finally
      StrStream.Free;

    end;
  finally
    BinStream.Free
  end;
end;

procedure ZeroOutMemory(Destination: Pointer; Length: integer);
begin
  FillChar(Destination^, Length, 0);
end;

function GetSystemType: TOpSysTypes;
var
  osVerInfo: TOSVersionInfo;
  majorVer, minorVer: integer;
begin
  // Result := OSUnknown;
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(osVerInfo) then
  begin
    majorVer := osVerInfo.dwMajorVersion;
    minorVer := osVerInfo.dwMinorVersion;
    case osVerInfo.dwPlatformId of
      VER_PLATFORM_WIN32_NT:
        begin // Windows NT/2000
          if majorVer <= 4 then
            Result := OSWinNT
          else if (majorVer = 5) and (minorVer = 0) then
            Result := OSWin2000
          else if (majorVer = 5) and (minorVer = 1) then
            Result := OSWinXP
          else
            Result := OSUnknown;
        end;
      VER_PLATFORM_WIN32_WINDOWS:
        begin // Windows 9x/ME
          if (majorVer = 4) and (minorVer = 0) then
            Result := OSWin95
          else if (majorVer = 4) and (minorVer = 10) then
          begin
            if osVerInfo.szCSDVersion[1] = 'A' then
              Result := OSWin98SE
            else
              Result := OSWin98;
          end
          else if (majorVer = 4) and (minorVer = 90) then
            Result := OSWinME
          else
            Result := OSUnknown;
        end;
    else
      Result := OSUnknown;
    end;
  end
  else
    Result := OSUnknown;
end;

function IsInvalidEmail(const S: string; AllowNA: Boolean = False): Boolean;
var
  i: integer;
  C: string;
begin // ' ', [, ], (, ), : in EMail-Address
  if AllowNA and ((S = 'NA') or (S = 'N/A')) then
  begin
    Result := False; // that is, this email is NOT invalid
    exit;
  end;

  Result := (Trim(S) = '') or (Pos(' ', AnsiLowerCase(S)) > 0) or
    (Pos('[', AnsiLowerCase(S)) > 0) or (Pos(']', AnsiLowerCase(S)) > 0) or
    (Pos('(', AnsiLowerCase(S)) > 0) or (Pos(')', AnsiLowerCase(S)) > 0) or
    (Pos(':', AnsiLowerCase(S)) > 0);
  if Result then
    exit; // @ not in EMail-Address;
  i := Pos('@', S);
  Result := (i = 0) or (i = 1) or (i = Length(S));
  if Result then
    exit;
  Result := (Pos('@', Copy(S, i + 1, Length(S) - 1)) > 0);
  if Result then
    exit; // Domain <= 1
  C := Copy(S, i + 1, Length(S));
  Result := Length(C) <= 1;
  if Result then
    exit;
  i := Pos('.', C);
  Result := (i = 0) or (i = 1) or (i = Length(C));
end;

function RightStr(aStr: string; Chars: integer): string;
begin
  if Length(aStr) > 0 then
    Result := Copy(aStr, Length(aStr) - Chars + 1, Length(aStr))
  else
    Result := '';
end;

function LeftEqStr(subStr, srcStr: string; CaseInsensitive : Boolean = false): Boolean;
begin
  if CaseInsensitive then
  begin
    srcStr := uppercase(srcStr);
    subStr := uppercase(subStr);
  end;
  Result := LeftStr(srcStr, length(subStr)) = subStr;
end;


function LeftStr(aStr: string; Chars: integer): string;
var
  II: integer;
begin
  if (Length(aStr) <= Chars) or (Chars < 1) then
  begin
    Result := aStr;
  end
  else
  begin
    if Length(aStr) > 0 then
    begin
      try
        Result := Copy(aStr, 1, Chars);
      except
        on E: Exception do
        begin
          Result := '';
          for II := 1 to Chars do
          begin
            Result := Result + aStr[II];
          end;
        end;
      end;
    end
    else
    begin
      Result := '';
    end;
  end;
end;

function ZeroLen(const aStr: string): Boolean;
begin
  Result := (Length(Trim(aStr)) = 0);
end;

function IsEmptyString(aStr: string; ignoreWhitespace: Boolean = True): Boolean;
begin
  if ignoreWhitespace then
    aStr := Trim(aStr);
  Result := (aStr = '');
end;

function FormatPhoneNumber(PhoneStr: string): string;
begin
  if Length(PhoneStr) = 10 then
    Result := Format('(%s) %s-%s', [Copy(PhoneStr, 1, 3), Copy(PhoneStr, 4, 3),
      Copy(PhoneStr, 7, 4)])
  else if Length(PhoneStr) = 7 then
    Result := Format('%s-%s', [Copy(PhoneStr, 1, 3), Copy(PhoneStr, 4, 4)])
  else
    Result := PhoneStr;
end;

function IsUpper(myChar: char): Boolean;
begin
  Result := IsCharUpper(myChar);
end;

function IsLower(myChar: char): Boolean;
begin
  Result := IsCharLower(myChar);
end;

function CharList(aList: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(aList) do
    Result := AddDelim(Result, singleQuote + aList[i] + singleQuote);
end;

function QuoteEscape(const Value: string; const QuoteChar: char = SINGLEQUOTE): string;
var
  i: Integer;
begin
  Result := Value;
  for i := Length(Result) downto 1 do
    if Result[i] = QuoteChar then
      Insert(QuoteChar, Result, i);
end;

function QuotedList(const aList: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to ListLen(aList, ';') do
    Result := AddDelim(Result, singleQuote + QuoteEscape(Trim(ListGetAt(aList,
      i, ';'))) + singleQuote);
end;

function ListNamesToDelim(aList: { TStrings; } TStringList;
  const QuoteChar: char = #0): string;
var
  i: integer;
begin
  for i := 0 to aList.count - 1 do
    Result := AddDelim(Result, IfThen(QuoteChar <> #0, QuoteChar) + aList.Names
      [i] + IfThen(QuoteChar <> #0, QuoteChar));
end;

function Append_YYYYMMDD(aStr : String; dt : TDateTime): string;
var y, m, d: word;
begin
  DecodeDate(dt, y, m, d);
  Result := aStr + '_' +
  LPad(IntToStr(y),4,'0') + LPad(IntToStr(m),2,'0') + LPad(IntToStr(d),2,'0');
end;

function Append_YYYYMMDDHHNN(aStr : String; dt : TDateTime): string;
var hh, mm, ss, ms: word;
begin
  Result := Append_YYYYMMDD(aStr, dt);
  DecodeTime(dt, hh, mm, ss, ms);
  Result := Result + LPad(IntToStr(hh),2,'0') + LPad(IntToStr(mm),2,'0');
end;

function SqlLiteDate(const dt: tDatetime): string;
var
  y, m, d: word;
  aStr: string;
begin // returns a date formatted (without the single quotes) as '2002-08-05'
  DecodeDate(dt, y, m, d);
  Result := IntToStr(y) + '-';
  aStr := IntToStr(m);
  if Length(aStr) < 2 then
    aStr := '0' + aStr;
  Result := Result + aStr + '-';
  aStr := IntToStr(d);
  if Length(aStr) < 2 then
    aStr := '0' + aStr;
  Result := Result + aStr;
end;

function SqliteDateTime(const dt: tDatetime): string;
var
  h, m, s, ms : word;
begin // returns a date formatted (without the single quotes) as '2002-08-05 02:03:04'
  Result := SqlLiteDate(dt) + ' ';
  DecodeTime(dt, h, m, s, ms);
  Result := Result + LPad(IntToStr(h),2,'0') + ':';
  Result := Result + LPad(IntToStr(m),2,'0') + ':';
  Result := Result + LPad(IntToStr(s),2,'0');
end;

function SqliteEncodeDateTime(dtStr, tmStr : String) : TDateTime;
begin       //12/28/15  and  15:10:44  for inputs

{$IFDEF VER150}
      Result := DateUtils.EncodeDateTime(StoI(Copy(dtStr, 7, 2)) + 2000, // yr
{$ELSE}
      Result := System.DateUtils.EncodeDateTime(StoI(Copy(dtStr, 7, 2)) + 2000, // yr
{$ENDIF}

        StoI(Copy(dtStr, 1, 2)), // mo
        StoI(Copy(dtStr, 4, 2)), // day
        StoI(Copy(tmStr, 1, 2)), // hr
        StoI(Copy(tmStr, 4, 2)), // mi
        StoI(Copy(tmStr, 7, 2)), // sec
        0); // milliseconds
end;

function SQLStrEncode(const Value: string): string;
var
  i: integer;
begin
  Result := Value;
  for i := Length(Result) downto 1 do
    if Result[i] = singleQuote then
      Insert(singleQuote, Result, i);
end;

function SQLSingleQuote(const Value: string): string;
begin
  Result := singleQuote + SQLStrEncode(Value) + singleQuote;
end;

function SQLBracket(const Value: string): string;
begin
  Result := '[' + SQLStrEncode(Value) + ']';
end;

function SQ(const Value: string): string;
begin
  Result := singleQuote + Value + singleQuote;
end;

procedure UnpackPath(FileSpec: string; var Drive, PathPart, FileName,
  FileExt: string; FullFilename: Boolean = False);
begin // C:\dir1\dir2\myfile.txt
  Drive := ExtractFileDrive(FileSpec); // C
  PathPart := ExtractFilePath(FileSpec); // dir1\dir2
  FileName := ExtractFileName(FileSpec); // myfile.txt
  FileExt := ExtractFileExt(FileName); // .txt
  if not FullFilename then
    FileName := Copy(FileName, 1, Length(FileName) - Length(FileExt)); // myfile
end;

function GetShortPath(Path: string; Count: Integer): string;
// from Greatis Software
  procedure Slashes(var Str: string; var Num: Integer);
  var
    Position, Index: Integer;
  begin
    Index:=0;
    repeat
      Position:=Pos('\', Str);
      Delete(Str,1,Position);
      if Position<>0 then Inc(Index);
      if (Index=Num)and(Num<>0) then break;
    until Position=0;
    Num:=Index;
  end;

var
  Num, NewNum, P: Integer;
  Str: string;
begin
  Str:=Path;
  Num:=0;
  Slashes(Path, Num);
  while (Length(Str)>Count)and(Num>2) do
  begin
    NewNum:=Num div 2;
    Path:=Str;
    Slashes(Path, NewNum);
    P:=Pos(Path, Str);
    Delete(Str,P, Length(Path));
    NewNum:=2;
    Slashes(Path, NewNum);
    Str:=Str+'...\'+Path;
    Dec(Num);
  end;
  Result:=Str;
end;

function IsIn(const aStrg: string; aStrgs: array of string;
  aIgnoreCase: Boolean): Boolean;
var
  II: integer;
begin
  Result := False;
  II := Low(aStrgs);
  while (not Result) and (II <= high(aStrgs)) do
  begin
    Result := (aIgnoreCase and AnsiSameText(aStrg, aStrgs[II])) or
      (AnsiSameStr(aStrg, aStrgs[II]));
    inc(II);
  end;
end;

function StringIndex(const aStrg: string; aStrgs: array of string;
  aIgnoreCase: Boolean): integer;
var
  II: integer;
  Ix: integer;
begin
  II := Low(aStrgs);
  Ix := Low(aStrgs) - 1;
  while (Ix = Low(aStrgs) - 1) and (II <= high(aStrgs)) do
  begin
    if (aIgnoreCase and AnsiSameText(aStrg, aStrgs[II])) or
      (AnsiSameStr(aStrg, aStrgs[II])) then
      Ix := II;
    inc(II);
  end;
  Result := Ix;
end;

function EscapeAmpersands(const S: string): string;
{ Replaces any '&' characters with '&&' to remove Accelerator Keys }
begin
  Result := StringReplace(S, '&', '&&', [rfReplaceAll]);
end;

function ComputerName: string;
var
  buffer: array [0 .. MAX_COMPUTERNAME_LENGTH + 1] of char;
  Size: Cardinal;
begin
  try
    Result := '';
    Size := MAX_COMPUTERNAME_LENGTH + 1;
    if Windows.GetComputerName(@buffer, Size) then
      Result := StrPas(buffer);
  except
    Result := '';
  end;
end;

function ExtractFileNameWithoutExt(const FileName: string): string;
begin
  Result := ChangeFileExt(ExtractFileName(FileName), '');
end;

function FileVersion(FileName: string; var v1, v2, v3, v4: integer): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  if VerInfoSize = 0 then
    exit;
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    v1 := dwFileVersionMS shr 16;
    v2 := dwFileVersionMS and $FFFF;
    v3 := dwFileVersionLS shr 16;
    v4 := dwFileVersionLS and $FFFF;

    Result := IntToStr(v1);
    Result := Result + '.' + IntToStr(v2);
    Result := Result + '.' + IntToStr(v3);
    Result := Result + '.' + IntToStr(v4);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

function FileVersionStr(FileName: string): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  v1, v2, v3, v4: integer;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  if VerInfoSize = 0 then
    exit;
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    v1 := dwFileVersionMS shr 16;
    v2 := dwFileVersionMS and $FFFF;
    v3 := dwFileVersionLS shr 16;
    v4 := dwFileVersionLS and $FFFF;

    Result := IntToStr(v1);
    Result := Result + '.' + IntToStr(v2);
    Result := Result + '.' + IntToStr(v3);
    Result := Result + '.' + IntToStr(v4);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

function getSubStrCharSeperated(LongString: string; SubSt: char;
  LocNum: integer): string;
var
  licount: integer;
  liend: integer;
  // lstemp : string;
begin
  licount := 0;
  Result := '';
  while (LocNum <> licount) do
  begin
    inc(licount);
    liend := Pos(SubSt, LongString);
    if (liend = 0) and (Length(LongString) > 0) then
      liend := Length(LongString) + 2;
    if Length(LongString) > 0 then
      Result := Copy(LongString, 1, liend - 1)
    else
      Result := '';
    LongString := LStrTrim(Copy(LongString, liend + 1,
      Length(LongString) - liend + 1));
  end;
end;


// Use CalcCRC32 as a procedure so CRCValue can be passed in but
// also returned. This allows multiple calls to CalcCRC32 for
// the "same" CRC-32 calculation.
// 1. exclusive-or the input byte with the low-order byte of the CRC register to get an INDEX
// 2. shift the CRC register eight bits to the right
// 3. exclusive-or the CRC register with the contents of Table[INDEX]
// 4. repeat steps 1 through 3 for all bytes

procedure CalcCRC32(P: Pointer; ByteCount: DWORD; var CRCValue: DWORD);
var
  i: DWORD;
  q: ^byte;
begin
  q := P;
  for i := 0 to ByteCount - 1 do
  begin
    CRCValue := (CRCValue shr 8) xor PolyTable[q^ xor (CRCValue and $000000FF)];
    inc(q)
  end
end { CalcCRC32 };

procedure CalcFileCRC32(FromName: string; var CRCValue: DWORD;
  var TotalBytes: TInteger8; var error: word);
var
  Stream: TMemoryStream;
begin
  error := 0;
  CRCValue := $FFFFFFFF;
  Stream := TMemoryStream.Create;
  try
    try
      Stream.LoadFromFile(FromName);
      if Stream.Size > 0 then
        CalcCRC32(Stream.Memory, Stream.Size, CRCValue)
    except
      on E: EReadError do
        error := 1
    end;
    CRCValue := not CRCValue
  finally
    Stream.Free
  end;
end;

function GetEnvVarValue(const VarName: string): string;
var
  BufSize: integer; // buffer size required for value
begin
  // Get required buffer size (inc. terminal #0)
  BufSize := GetEnvironmentVariable(PChar(VarName), nil, 0);
  if BufSize > 0 then
  begin
    // Read env var value into result string
    SetLength(Result, BufSize - 1);
    GetEnvironmentVariable(PChar(VarName), PChar(Result), BufSize);
  end
  else // No such environment variable
    Result := '';
end;

function SetEnvVarValue(const VarName, VarValue: string): integer;
begin
  // Simply call API function
  if SetEnvironmentVariable(PChar(VarName), PChar(VarValue)) then
    Result := 0
  else
    Result := GetLastError;
end;
// works, but not using now
//function ForegroundWindowTitle : String;
//var FromtheTitle :PChar;
//    ForegroundHND : THandle;
//begin
//  ForeGroundHND:=getForeGroundWindow;
//  GetMem(FromtheTitle, 100);
//  try
//    GetWindowText(ForeGroundHND, PChar(FromtheTitle), 800);
//    Result := FromtheTitle;
//  finally
//    FreeMem(FromtheTitle);
//  end;
//end;

procedure ShellExecute_AndWait(FileName: string; Params: string;
  Wait: Boolean = True; NORMAL : boolean = true);
var
  exInfo: TShellExecuteInfo;
  Ph: DWORD;
begin
  FillChar(exInfo, SizeOf(exInfo), 0);
  with exInfo do
  begin
    cbSize := SizeOf(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    exInfo.lpVerb := 'open';
    exInfo.lpParameters := PChar(Params);
    lpFile := PChar(FileName);
    if NORMAL then
      nShow := SW_SHOWNORMAL
    else
      nShow := SW_HIDE;
  end;
  if ShellExecuteEx(@exInfo) then
    Ph := exInfo.HProcess
  else
  begin
    // ShowMessage(SysErrorMessage(GetLastError));
    exit;
  end;
  if Wait then
    while WaitForSingleObject(exInfo.HProcess, 50) <> WAIT_OBJECT_0 do
      Application.ProcessMessages;
  CloseHandle(Ph);
end;

function WinExecAndWait32(FileName: string; Visibility: integer = SW_SHOWNORMAL)
  : Longword;
var { by Pat Ritchey }
  zAppName: array [0 .. 512] of char;
  zCurDir: array [0 .. 255] of char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil, zAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS, nil, // pointer to new environment block
    nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo) { // pointer to PROCESS_INF } then
    Result := WAIT_FAILED
  else
  begin
    WaitForSingleObject(ProcessInfo.HProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.HProcess, Result);
    CloseHandle(ProcessInfo.HProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end; { WinExecAndWait32 }

function FilesExist(StartDir, FileMask: string;subdirs: Boolean = True): Boolean;
var slist: TStringlist;
begin
  slist := TStringlist.Create;
  try
    FindFiles(slist, StartDir, FileMask, subDirs);
    Result := (slist.Count > 0)
  finally
    slist.Free;
  end;
end;

procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string;
  subdirs: Boolean = True; olderThan: TDateTime = 0; newerThan: TDateTime = 0);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
  dt: TDateTime;
begin
  if StartDir[Length(StartDir)] <> '\' then
    StartDir := StartDir + '\';
  { Build a list of the files in directory StartDir  (not the directories!) }
  IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
  while IsFound do
  begin
    if olderThan > 0 then begin   // do only if default 0 is not used
      if FileAge(StartDir + SR.Name, dt) and (dt < olderThan) then
        FilesList.Add(StartDir + SR.Name);
    end
    else
    if newerThan > 0 then begin   // do only if default 0 is not used
      if FileAge(StartDir + SR.Name, dt) and (dt > newerThan) then
        FilesList.Add(StartDir + SR.Name);
    end
    else
      FilesList.Add(StartDir + SR.Name);

    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Build a list of subdirectories
  if subdirs then
  begin
    DirList := TStringList.Create;
    IsFound := FindFirst(StartDir + '*.*', faAnyFile, SR) = 0;
    while IsFound do
    begin
      if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
        DirList.Add(StartDir + SR.Name);
      IsFound := FindNext(SR) = 0;
    end;
    FindClose(SR);
    // Scan the list of subdirectories
    for i := 0 to DirList.count - 1 do
      FindFiles(FilesList, DirList[i], FileMask, subDirs, olderThan, newerThan);

    DirList.Free;
  end;

end;

// delete older logs, etc. is a common need, so here a simple function to delete
// matching files from a single folder (or tree) older than the given number of days

procedure DeleteOlderFiles(const Folder, FileMask: string; AgeInDays: integer; subDirs: boolean=false);
var FileList: TStringList;
    ii: integer;
begin
  FileList := TStringList.Create;
  try
    FindFiles(FileList, Folder, FileMask, subDirs, Date - AgeInDays);
    // originally I coded this using for fname in FileList and discovered a
    // compiler bug where the last filename was repeated -- this was not a
    // repeatable bug in other environments.
    for ii := 0 to FileList.Count - 1 do
      TFile.Delete(FileList[ii]);
  finally
    FileList.Free;
  end;
end;

function PatchAsciiFilename(const fname: string; AllowPathCharacters: boolean): string;
var
  c: char;
begin
  // valid unicode filenames are much more extensive.
  result := '';
  for c in FName do begin
    // this is not a complete list of legal windows filesname characters, for example semicolon is legal
    // but very uncommon and subject to confusion
    if c in ['a'..'z', 'A'..'Z', '0'..'9', ' ', '.', '+', '-', '_', '(', ')',
             '[', ']', '{', '#', '!', '$', '%', '=', '~', '@'] then
      result := result + c
    else if AllowPathCharacters and (c in [':', '\', '/'])  then
      result := result + c
    else
      result := result + '_';
  end;

  result := trim(result);

  // fix reserved names like 'CON', 'PRN', 'LPT1', etc.
  // if MatchStr(result, ['con','aux','prn','nul','com1','com2','com3','com4','com5','com6','com7','com8','com9','lpt1','lpt2','lpt3','lpt4','lpt5','lpt6','lpt7','lpt8','lpt9']) then
  if MatchText(result, ['con','aux','prn','nul','com1','com2','com3','com4','com5','com6','com7','com8','com9','lpt1','lpt2','lpt3','lpt4','lpt5','lpt6','lpt7','lpt8','lpt9']) then
    result := result + '!'
end;


function CharFromVirtualKey(Key: word): string;
var
  keyboardState: TKeyboardState;
  asciiResult: integer;
begin
  GetKeyboardState(keyboardState);

  SetLength(Result, 2);
  asciiResult := ToAscii(Key, MapVirtualKey(Key, 0), keyboardState,
    @Result[1], 0);
  case asciiResult of
    0:
      Result := '';
    1:
      SetLength(Result, 1);
    2:
      ;
  else
    Result := '';
  end;
end;

function IAddrToHostName(const IP: Ansistring): Ansistring;
var
  i: integer;
  P: PHostEnt;
begin
  Result := '';
  i := inet_addr(PAnsiChar(IP));
  if i <> u_long(INADDR_NONE) then
  begin
    P := GetHostByAddr(@i, SizeOf(integer), PF_INET);
    if P <> nil then
      Result := P^.h_name;
  end
  else
    Result := 'Invalid IP address';
end;

function StripCharSet(srcStr, StripStr: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(srcStr) do
    if not Contains(srcStr[i], StripStr) then
      Result := Result + srcStr[i];
end;

function processExists(exeFileName: string): Boolean;
var
  ContinueLoop: Boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  ExtFileName, ProFileName: string;
begin
  Result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while ContinueLoop do
  begin
    exeFileName := UpperCase(exeFileName);
    ProFileName := UpperCase(FProcessEntry32.szExeFile);
    ExtFileName := ExtractFileName(ProFileName);
    Result := (ExtFileName = exeFileName) or (ProFileName = exeFileName);
    if Result then
      Break;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function MMDDYYYY(myDate: tDatetime): string;
var
  mm, dd, yy: word;
begin
  DecodeDate(myDate, yy, mm, dd);
  Result := LPad(ItoS(mm), 2, '0') + LPad(ItoS(dd), 2, '0') +
    LPad(ItoS(yy), 4, '0');
end;

function YYMMDD(myDate: tDatetime): string;
var
  mm, dd, yy: word;
begin
  DecodeDate(myDate, yy, mm, dd);
  Result := RightStr(ItoS(yy), 2) + LPad(ItoS(mm), 2, '0') +
    LPad(ItoS(dd), 2, '0');
end;

function HHMMSS(myTime: tDatetime): string;
var
  hh, mm, ss, xx: word;
begin
  DecodeTime(myTime, hh, mm, ss, xx);
  Result := LPad(ItoS(hh), 2, '0') + LPad(ItoS(mm), 2, '0') +
    LPad(ItoS(ss), 2, '0');
end;

function Base64Encode(S: string): string;
const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
var
  i: integer;
  A: integer;
  x: integer;
  b: integer;
begin
  Result := '';
  A := 0;
  b := 0;
  for i := 1 to Length(S) do
  begin
    x := Ord(S[i]);
    b := b * 256 + x;
    A := A + 8;
    while A >= 6 do
    begin
      A := A - 6;
      x := b div (1 shl A);
      b := b mod (1 shl A);
      Result := Result + Codes64[x + 1];
    end;
  end;
  if A > 0 then
  begin
    x := b shl (6 - A);
    Result := Result + Codes64[x + 1];
  end;
end;

function Base64Decode(S: string): string;
const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
var
  i: integer;
  A: integer;
  x: integer;
  b: integer;
begin
  Result := '';
  A := 0;
  b := 0;
  for i := 1 to Length(S) do
  begin
    x := Pos(S[i], Codes64) - 1;
    if x >= 0 then
    begin
      b := b * 64 + x;
      A := A + 6;
      if A >= 8 then
      begin
        A := A - 8;
        x := b shr A;
        b := b mod (1 shl A);
        x := x mod 256;
        Result := Result + chr(x);
      end;
    end
    else
      exit;
  end;
end;

function SetFocusTo(ctrl: TControl): Boolean;
begin
  Result := False;
  try
    if (ctrl <> nil) and (Application.Active) and (ctrl is TWinControl) and (TWinControl(ctrl).CanFocus) then
    begin
      TWinControl(ctrl).setfocus;
      Result := true;
    end;
  except end;
end;

function ClearKeyboardBuffer: Boolean;
var
  Msg: TMsg;
begin
  Result := True;
  try
    while PeekMessage(Msg, 0, WM_KEYFIRST, WM_KEYLAST,
      PM_REMOVE or PM_NOYIELD) do;
  except
    Result := False;
  end;
end;

function GetGlobalOffline: Boolean;
var
  Reg: TRegistry;
  RegWORD: DWORD;
const
  RVAL = 'GlobalUserOffline';
  RKEY = 'Software\Microsoft\Windows\CurrentVersion\Internet Settings';
  RegKeyExists: Boolean = False;
begin
  Result := False;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  if not RegKeyExists then
    RegKeyExists := Reg.KeyExists(RKEY);
  if RegKeyExists then
    try
      if Reg.OpenKeyReadOnly(RKEY) and Reg.ValueExists(RVAL) then
      begin
        RegWORD := Reg.ReadInteger(RVAL);
        Reg.CloseKey;
        Result := (RegWORD <> 0);
      end;
    finally
      Reg.Free
    end;
end;

procedure SetGlobalOffline(bOffline: Boolean);
var
  ici: TInternetConnectedInfo;
begin
  ici.dwFlags := 0;
  if bOffline then
  begin
    ici.dwConnectedState := INTERNET_STATE_DISCONNECTED_BY_USER;
    ici.dwFlags := ISO_FORCE_DISCONNECTED;
  end
  else
  begin
    ici.dwConnectedState := INTERNET_STATE_CONNECTED;
  end;
  InternetSetOption(nil, INTERNET_OPTION_CONNECTED_STATE, @ici, SizeOf(ici));
end;

function BoolValue(aBool: Boolean): string;
begin
  if (aBool) then
    Result := 'True'
  else
    Result := 'False';
end;

function IIfDate(aBool: Boolean; aTrueDate, aFalseDate: tDatetime): tDatetime;
begin
  if (aBool) then
    Result := aTrueDate
  else
    Result := aFalseDate;
end;

function IIfDouble(aBool: Boolean; const aTrueStrg, aFalseStrg: double): double;
begin
  if (aBool) then
    Result := aTrueStrg
  else
    Result := aFalseStrg;
end;

function IIfInt(aBool: Boolean; aTrueInt, aFalseInt: integer): integer;
begin
  if (aBool) then
    Result := aTrueInt
  else
    Result := aFalseInt;
end;

function IIfStrg(aBool: Boolean; const aTrueStrg, aFalseStrg: string): string;
begin
  if (aBool) then
    Result := aTrueStrg
  else
    Result := aFalseStrg;
end;

function ShiftStateToString(Shift: TShiftState): string;
begin
  Result := '';
  //
  if (ssAlt in Shift) then
    Result := Result + '{Alt}+';
  if (ssShift in Shift) then
    Result := Result + '{Shift}+';
  if (ssCtrl in Shift) then
    Result := Result + '{Ctrl}+';
  if (ssLeft in Shift) then
    Result := Result + '{LeftMouse}+';
  if (ssRight in Shift) then
    Result := Result + '{RightMouse}+';
  if (ssMiddle in Shift) then
    Result := Result + '{MiddleMouse}+';
  if (ssDouble in Shift) then
    Result := Result + '{DoubleMouse}+';
end;

function KeyboardValue(aKey: word): string;
begin
  if (Length(KEYBOARD_KEYS[aKey]) > 0) then
  begin
    Result := KEYBOARD_KEYS[aKey];
  end
  else
  begin
    Result := CharFromVirtualKey(aKey);
  end;
end;

{$IFDEF VER150}
function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;
{$ENDIF}

procedure PrintDocToDefaultPrinter(Handle: HWND; FileSpec: string);
begin // especially good for pdf, etc
  try
    ShellExecute(Handle, 'print', PChar(FileSpec), nil, nil, SW_HIDE);
  except
  end;
end;

function GetNextTagFromXML(const aXML: string; aStartChar: integer = 1): string;
var
  II: integer;
  TagChar: char;
const
  BEGTAG: char = '<';
  ENDTAG: char = '>';
  SLASH: char = '/';
begin
  //
  II := aStartChar;
  while (II < Length(aXML)) and (aXML[II] <> BEGTAG) do
  begin
    inc(II);
  end;
  //
  Result := '';
  while (II < Length(aXML)) do
  begin
    inc(II);
    TagChar := aXML[II];
    if (TagChar = SLASH) or (TagChar = ENDTAG) then
    begin
      II := Length(aXML);
    end
    else
    begin
      Result := Result + TagChar;
    end;
  end;
end;

function GetNodesFromXML(const aXML: string; var aNodes: TStringList): integer;
var
  Ch: char;
  EndMark: integer;
  Temp: string;
  Working: string;
const
  BEGTAG: char = '<';
  ENDTAG: char = '>';
  SLASH: char = '/';
begin
  //
  Working := aXML;
  Result := 0;
  //
  if Assigned(aNodes) then
  begin
    aNodes.Clear;
  end
  else
  begin
    aNodes := TStringList.Create;
  end;
  //
  try
    if (Pos(BEGTAG, Working) > 0) and (Pos(ENDTAG, Working) > 0) then
    begin
      try
        while (Length(Working) > 0) do
        begin
          EndMark := Pos(ENDTAG, Working); // find >
          if (EndMark = 0) then
          begin
            EndMark := Length(Working);
          end;
          if (EndMark < Length(Working)) then
          begin
            Ch := Working[EndMark - 1];
            if (Ch = SLASH) then
            begin
              EndMark := EndMark + 1;
            end
            else
            begin
              Ch := Working[EndMark + 1];
              if (Ch = BEGTAG) then
              begin
              end
              else
              begin
                EndMark := EndMark + 1;
                while (EndMark <= Length(Working)) and
                  (Working[EndMark] <> ENDTAG) do
                begin
                  inc(EndMark);
                end;
              end;
            end;
          end;
          Temp := Copy(Working, 1, EndMark);
          aNodes.Add(Format('%s', [Temp]));
          Delete(Working, 1, EndMark);
        end;
      finally
        Result := aNodes.count;
      end;
    end;
  except
  end;
end;

function RemoveWSDLFromURL(URLIn: string): string;
begin
  Result := URLIn;
  if UpperCase(RightStr(Result, 5)) = '?WSDL' then
    Result := Copy(Result, 1, Length(Result) - 4);
end;

function UpperCaseFirstLetterEachWord(aStr: String): String;
var i : integer;
begin
  Result := lowerCase(aStr);
  for i := 1 to length(Result) do
    if i = 1 then
      Result[i] := upCase(Result[i])
    else
      if CharInSet(Result[i-1], [' ', '.', ',']) then
        Result[i] := upCase(Result[i])
end;

procedure InitializeKeyboardKeys;
var
  KK: integer;
begin
  //
  KK := low(KEYBOARD_KEYS);
  while (KK <= high(KEYBOARD_KEYS)) do
  begin
    KEYBOARD_KEYS[KK] := '';
    inc(KK);
  end;
  //
  KEYBOARD_KEYS[VK_LBUTTON] := '<LEFT BUTTON>';
  KEYBOARD_KEYS[VK_RBUTTON] := '<RIGHT BUTTON>';
  KEYBOARD_KEYS[VK_CANCEL] := '<CANCEL>';
  KEYBOARD_KEYS[VK_MBUTTON] := '<MIDDLE BUTTON>';
  KEYBOARD_KEYS[VK_BACK] := '<BACKSPACE>';
  KEYBOARD_KEYS[VK_TAB] := '<TAB>';
  KEYBOARD_KEYS[VK_CLEAR] := '<CLEAR>';
  KEYBOARD_KEYS[VK_RETURN] := '<RETURN>';
  KEYBOARD_KEYS[VK_SHIFT] := '<Shift>';
  KEYBOARD_KEYS[VK_CONTROL] := '<Control>';
  KEYBOARD_KEYS[VK_MENU] := '<Menu>';
  KEYBOARD_KEYS[VK_PAUSE] := '<Pause>';
  KEYBOARD_KEYS[VK_CAPITAL] := '<CAPITAL>';
  KEYBOARD_KEYS[VK_KANA] := '<KANA>';
  KEYBOARD_KEYS[VK_HANGUL] := '<HANGUL>';
  KEYBOARD_KEYS[VK_JUNJA] := '<JUNJA>';
  KEYBOARD_KEYS[VK_FINAL] := '<FINAL>';
  KEYBOARD_KEYS[VK_HANJA] := '<HANJA>';
  KEYBOARD_KEYS[VK_KANJI] := '<KANJI>';
  KEYBOARD_KEYS[VK_CONVERT] := '<CONVERT>';
  KEYBOARD_KEYS[VK_NONCONVERT] := '<NONCONVERT>';
  KEYBOARD_KEYS[VK_ACCEPT] := '<ACCEPT>';
  KEYBOARD_KEYS[VK_MODECHANGE] := '<MODECHANGE>';
  KEYBOARD_KEYS[VK_SPACE] := '<SPACE>';
  KEYBOARD_KEYS[VK_DOWN] := '<DOWN-ARROW>';
  KEYBOARD_KEYS[VK_UP] := '<UP-ARROW>';
  KEYBOARD_KEYS[VK_NEXT] := '<PAGE-DOWN>';
  KEYBOARD_KEYS[VK_PRIOR] := '<PAGE-UP>';
  KEYBOARD_KEYS[VK_RIGHT] := '<RIGHT-ARROW>';
  KEYBOARD_KEYS[VK_LEFT] := '<LEFT-ARROW>';
  KEYBOARD_KEYS[VK_END] := '<END>';
  KEYBOARD_KEYS[VK_UP] := '<UP>';
  KEYBOARD_KEYS[VK_DOWN] := '<DOWN>';
  KEYBOARD_KEYS[VK_SELECT] := '<SELECT>';
  KEYBOARD_KEYS[VK_PRINT] := '<PRINT>';
  KEYBOARD_KEYS[VK_EXECUTE] := '<EXECUTE>';
  KEYBOARD_KEYS[VK_SNAPSHOT] := '<SNAPSHOT>';
  KEYBOARD_KEYS[VK_INSERT] := '<INSERT>';
  KEYBOARD_KEYS[VK_DELETE] := '<DELETE>';
  KEYBOARD_KEYS[VK_HELP] := '<HELP>';
  KEYBOARD_KEYS[VK_RETURN] := '<RETURN>';
  KEYBOARD_KEYS[VK_MENU] := '<MENU>';
  KEYBOARD_KEYS[VK_ESCAPE] := '<ESCAPE>';
  KEYBOARD_KEYS[VK_TAB] := '<TAB>';
  KEYBOARD_KEYS[VK_CLEAR] := '<CLEAR>';
  KEYBOARD_KEYS[VK_BACK] := '<BACK>';
  KEYBOARD_KEYS[VK_HOME] := '<HOME>';
  KEYBOARD_KEYS[VK_END] := '<END>';
  KEYBOARD_KEYS[VK_INSERT] := '<INSERT>';
  KEYBOARD_KEYS[VK_DELETE] := '<DELETE>';
  KEYBOARD_KEYS[VK_CAPITAL] := '<CAPITAL>';
  KEYBOARD_KEYS[VK_PAUSE] := '<PAUSE>';
  KEYBOARD_KEYS[VK_NUMLOCK] := '<NUMLOCK>';
  KEYBOARD_KEYS[VK_SNAPSHOT] := '<SNAPSHOT>';
  KEYBOARD_KEYS[VK_SCROLL] := '<SCROLL>';
  KEYBOARD_KEYS[VK_HELP] := '<HELP>';
  KEYBOARD_KEYS[VK_CANCEL] := '<CANCEL>';
  KEYBOARD_KEYS[VK_SELECT] := '<SELECT>';
  KEYBOARD_KEYS[VK_EXECUTE] := '<EXECUTE>';
  KEYBOARD_KEYS[VK_F1] := '<F1>';
  KEYBOARD_KEYS[VK_F2] := '<F3>';
  KEYBOARD_KEYS[VK_F3] := '<F3>';
  KEYBOARD_KEYS[VK_F4] := '<F4>';
  KEYBOARD_KEYS[VK_F5] := '<F5>';
  KEYBOARD_KEYS[VK_F6] := '<F6>';
  KEYBOARD_KEYS[VK_F7] := '<F7>';
  KEYBOARD_KEYS[VK_F8] := '<F8>';
  KEYBOARD_KEYS[VK_F9] := '<F9>';
  KEYBOARD_KEYS[VK_F10] := '<F10>';
  KEYBOARD_KEYS[VK_F11] := '<F11>';
  KEYBOARD_KEYS[VK_F12] := '<F12>';
  KEYBOARD_KEYS[VK_F13] := '<F13>';
  KEYBOARD_KEYS[VK_F14] := '<F14>';
  KEYBOARD_KEYS[VK_F15] := '<F15>';
  KEYBOARD_KEYS[VK_F16] := '<F16>';
  KEYBOARD_KEYS[VK_F17] := '<F17>';
  KEYBOARD_KEYS[VK_F18] := '<F18>';
  KEYBOARD_KEYS[VK_F19] := '<F19>';
  KEYBOARD_KEYS[VK_F20] := '<F20>';
  KEYBOARD_KEYS[VK_F21] := '<F21>';
  KEYBOARD_KEYS[VK_F22] := '<F22>';
  KEYBOARD_KEYS[VK_F23] := '<F23>';
  KEYBOARD_KEYS[VK_F24] := '<F24>';
  //
  KEYBOARD_KEYS[VK_LWIN] := '<LWIN>';
  KEYBOARD_KEYS[VK_RWIN] := '<RWIN>';
  KEYBOARD_KEYS[VK_APPS] := '<APPS>';
  KEYBOARD_KEYS[VK_NUMPAD0] := '<NUMPAD0>';
  KEYBOARD_KEYS[VK_NUMPAD1] := '<NUMPAD1>';
  KEYBOARD_KEYS[VK_NUMPAD2] := '<NUMPAD2>';
  KEYBOARD_KEYS[VK_NUMPAD3] := '<NUMPAD3>';
  KEYBOARD_KEYS[VK_NUMPAD4] := '<NUMPAD4>';
  KEYBOARD_KEYS[VK_NUMPAD5] := '<NUMPAD5>';
  KEYBOARD_KEYS[VK_NUMPAD6] := '<NUMPAD6>';
  KEYBOARD_KEYS[VK_NUMPAD7] := '<NUMPAD7>';
  KEYBOARD_KEYS[VK_NUMPAD8] := '<NUMPAD8>';
  KEYBOARD_KEYS[VK_NUMPAD9] := '<NUMPAD9>';
  KEYBOARD_KEYS[VK_MULTIPLY] := '<MULTIPLY>';
  KEYBOARD_KEYS[VK_ADD] := '<ADD>';
  KEYBOARD_KEYS[VK_SEPARATOR] := '<SEPARATOR>';
  KEYBOARD_KEYS[VK_SUBTRACT] := '<SUBTRACT>';
  KEYBOARD_KEYS[VK_DECIMAL] := '<DECIMAL>';
  KEYBOARD_KEYS[VK_DIVIDE] := '<DIVIDE>';
  KEYBOARD_KEYS[VK_NUMLOCK] := '<NUMLOCK>';
  KEYBOARD_KEYS[VK_SCROLL] := '<SCROLL>';
  KEYBOARD_KEYS[VK_LSHIFT] := '<LSHIFT>';
  KEYBOARD_KEYS[VK_RSHIFT] := '<RSHIFT>';
  KEYBOARD_KEYS[VK_LCONTROL] := '<LCONTROL>';
  KEYBOARD_KEYS[VK_RCONTROL] := '<RCONTROL>';
  KEYBOARD_KEYS[VK_LMENU] := '<LMENU>';
  KEYBOARD_KEYS[VK_RMENU] := '<RMENU>';

{$IFDEF VER150}
{$ELSE}
  KEYBOARD_KEYS[VK_SLEEP] := '<SLEEP>';
  KEYBOARD_KEYS[VK_XBUTTON1] := '<X BUTTON ONE>';
  KEYBOARD_KEYS[VK_XBUTTON2] := '<X BUTTON TWO>';
  KEYBOARD_KEYS[VK_BROWSER_BACK] := '<BROWSER_BACK>';
  KEYBOARD_KEYS[VK_BROWSER_FORWARD] := '<BROWSER_FORWARD>';
  KEYBOARD_KEYS[VK_BROWSER_REFRESH] := '<BROWSER_REFRESH>';
  KEYBOARD_KEYS[VK_BROWSER_STOP] := '<BROWSER_STOP>';
  KEYBOARD_KEYS[VK_BROWSER_SEARCH] := '<BROWSER_SEARCH>';
  KEYBOARD_KEYS[VK_BROWSER_FAVORITES] := '<BROWSER_FAVORITES>';
  KEYBOARD_KEYS[VK_BROWSER_HOME] := '<BROWSER_HOME>';
  KEYBOARD_KEYS[VK_VOLUME_MUTE] := '<VOLUME_MUTE>';
  KEYBOARD_KEYS[VK_VOLUME_DOWN] := '<VOLUME_DOWN>';
  KEYBOARD_KEYS[VK_VOLUME_UP] := '<VOLUME_UP>';
  KEYBOARD_KEYS[VK_MEDIA_NEXT_TRACK] := '<MEDIA_NEXT_TRACK>';
  KEYBOARD_KEYS[VK_MEDIA_PREV_TRACK] := '<MEDIA_PREV_TRACK>';
  KEYBOARD_KEYS[VK_MEDIA_STOP] := '<MEDIA_STOP>';
  KEYBOARD_KEYS[VK_MEDIA_PLAY_PAUSE] := '<MEDIA_PLAY_PAUSE>';
  KEYBOARD_KEYS[VK_LAUNCH_MAIL] := '<LAUNCH_MAIL>';
  KEYBOARD_KEYS[VK_LAUNCH_MEDIA_SELECT] := '<LAUNCH_MEDIA_SELECT>';
  KEYBOARD_KEYS[VK_LAUNCH_APP1] := '<LAUNCH_APP1>';
  KEYBOARD_KEYS[VK_LAUNCH_APP2] := '<LAUNCH_APP2>';
  KEYBOARD_KEYS[VK_OEM_1] := '<OEM_1>';
  KEYBOARD_KEYS[VK_OEM_PLUS] := '<OEM_PLUS>';
  KEYBOARD_KEYS[VK_OEM_COMMA] := '<OEM_COMMA>';
  KEYBOARD_KEYS[VK_OEM_MINUS] := '<OEM_MINUS>';
  KEYBOARD_KEYS[VK_OEM_PERIOD] := '<OEM_PERIOD>';
  KEYBOARD_KEYS[VK_OEM_2] := '<OEM_2>';
  KEYBOARD_KEYS[VK_OEM_3] := '<OEM_3>';
  KEYBOARD_KEYS[VK_OEM_4] := '<OEM_4>';
  KEYBOARD_KEYS[VK_OEM_5] := '<OEM_5>';
  KEYBOARD_KEYS[VK_OEM_6] := '<OEM_6>';
  KEYBOARD_KEYS[VK_OEM_7] := '<OEM_7>';
  KEYBOARD_KEYS[VK_OEM_8] := '<OEM_8>';
  KEYBOARD_KEYS[VK_OEM_102] := '<OEM_102>';
  KEYBOARD_KEYS[VK_PACKET] := '<PACKET>';
  KEYBOARD_KEYS[VK_PROCESSKEY] := '<PROCESSKEY>';
  KEYBOARD_KEYS[VK_ATTN] := '<ATTN>';
  KEYBOARD_KEYS[VK_CRSEL] := '<CRSEL>';
  KEYBOARD_KEYS[VK_EXSEL] := '<EXSEL>';
  KEYBOARD_KEYS[VK_EREOF] := '<EREOF>';
  KEYBOARD_KEYS[VK_PLAY] := '<PLAY>';
  KEYBOARD_KEYS[VK_ZOOM] := '<ZOOM>';
  KEYBOARD_KEYS[VK_NONAME] := '<NONAME>';
  KEYBOARD_KEYS[VK_PA1] := '<PA1>';
  KEYBOARD_KEYS[VK_OEM_CLEAR] := '<OEM_CLEAR>';
{$ENDIF}


end;

function YearsAgo(numYears: integer): tDatetime;
begin
  Result := DateUtils.IncYear(Now, -numYears);
end;

// Modern software should always use UTF-8 without BOM for trouble-free processing
// works with ancient software (when it is just ASCII) as well as modern software
// The following routines should help tame the BOM beast
// See https://en.wikipedia.org/wiki/Byte_order_mark
//
// This is not strictly accurate, it assumes encoding based on BOM, files
// could for example by UTF-16 (BE or LE) encoded without a BOM, if this becomes
// and issue, detection of such should be added.

function GetFileEncoding(const srcFile: string): TEncoding;
var
  buffer: array[0..4] of byte;
  f: TFileStream;
begin
  // *** Use Default of Encoding.Default (Ansi CodePage)
  result := TEncoding.Default;

  // *** Detect byte order mark if any - otherwise use the default
  f := TFileStream.Create(srcFile, fmOpenRead);
  f.Read(buffer, 5);
  f.Free;

  if (buffer[0] = $ef) and (buffer[1] = $bb) and (buffer[2] = $bf) then
    result := TEncoding.UTF8
  else if (buffer[0] = $fe) and (buffer[1] = $ff) or (buffer[0] = $ff) and (buffer[1] = $fe) then
    result := TEncoding.Unicode
//  delphi encoding does not support UTF32 -- hope we never see it, if so need the reverse encoding too
//  else if (buffer[0] = 0) and (buffer[1] = 0) and (buffer[2] = $fe) and (buffer[3] = $ff) then
//    result := TEncoding.UTF32
  else if (buffer[0] = $2b) and (buffer[1] = $2f) and (buffer[2] = $76) then
    result := TEncoding.UTF7;
end;

// Unicode BOM headers are rare, but this will convert such a file into UTF-8
// so that it can be safely processed as normal.
// This has teen tested to work for the UCS-2 LE BOM that we were getting
// from some vendor.

procedure RemoveBOMHeader(const fname: string);
var lst: TStringList;
    enc: TEncoding;
begin
  // wasteful to load and save when it is not needed 99.97% of the time, by not
  // a performance issue yet. However, it is useful to leave timestamps alone, etc.
  enc := GetFileEncoding(fname);
  if enc = TEncoding.Default then
    exit;

  // If large files are processed, need to make conversion base on streams
  lst := TStringList.Create;
  lst.LoadFromfile(fname);
  lst.WriteBOM := false;
  lst.SaveToFile(fname, TEncoding.UTF8);
  lst.Free;
end;

function SaveStringToFile(S, FileNameStr: string; append : Boolean = false; prepend : Boolean = false): Boolean;
var
  slist: TStringList;
begin
  slist := TStringList.Create;
  try
    try
      if append then begin
        if FileExists(FileNameStr) then
          slist.LoadFromFile(FileNameStr);
      end;

      if prepend then
        slist.Insert(0, S)
      else
        slist.Text := slist.Text + S;
      slist.SaveToFile(FileNameStr);
      Result := True;
    finally
      slist.Free;
    end;
  except
    Result := False;
  end;
end;

function LoadStringFromFile(FileNameStr: string; index : integer = -1): string;
var
  slist: TStringList;
begin
  slist := TStringList.Create;
  try
    try
      slist.LoadFromFile(FileNameStr);
      if index > -1 then begin
        if slist.Count >= index then
          Result := slist[index];
      end
      else
        Result := slist.Text;
    finally
      slist.Free;
    end;
  except
    Result := '';
  end;
end;

// don't care if file timestamps don't match
function FileBytesIdentical(const file1, file2: string): boolean;
const blocksize = 1048576; // 1MByte
var
  fs1, fs2: TFileStream;
  b1, b2: array of byte;
  n1, n2: integer;
  fileLength: Int64;
begin
  result := false;

  setlength(b1, blocksize);
  setlength(b2, blocksize);
  fs1 := nil;
  fs2 := nil;

  try
    fs1 := TFileStream.Create(file1, fmOpenRead or fmShareDenyWrite);
    if (fs1=nil) then
      exit;
    fs2 := TFileStream.Create(file2, fmOpenRead or fmShareDenyWrite);
    if (fs2=nil) then
      exit;

    fileLength := fs1.Size;

    while fs1.Position < fileLength do begin
      n1 := fs1.Read(b1[0], blocksize);
      n2 := fs2.Read(b2[0], blocksize);
      if n1 <> n2 then
        exit;
      if not CompareMem(@b1[0], @b2[0], n1) then
        exit;
    end;
    result := true;

  finally
    setlength(b1,0);
    setlength(b2,0);
    fs2.free;
    fs1.free;
  end;

end;

procedure CopyFile(const FSrc, FDst: string);
var
  sStream,
  dStream: TFileStream;
begin
  sStream := TFileStream.Create(FSrc, fmOpenRead + fmShareDenyNone);
  try
    dStream := TFileStream.Create(FDst, fmCreate);
    try
      dStream.CopyFrom(sStream, 0);
    finally
      dStream.Free;
    end;
  finally
    sStream.Free;
  end;
end;

function InPrinterList(aPrinter: string): Boolean;
begin
  Result := (printer.Printers.IndexOf(aPrinter) > -1);
end;

function GetDefaultPrinter: string;
var
  ResStr: array [0 .. 255] of char; // AnsiChar;
  i: integer;
begin
  GetProfileString('Windows', 'device', '', ResStr, 255);
  Result := StrPas(ResStr);
  i := Pos(',', Result);
  if i > 0 then
    Result := Copy(Result, 1, i - 1);
end;

{ This shell command works both in XP and Win7. Not tested for Win8 or higher -- Jay Faubion
  To bring up a list of available commands, and see examples, do this in a DOS box:
  rundll32 printui.dll,PrintUIEntry /?
}

function SwitchToPrinter(vclPrinterName: String): integer;
var oldIndex : Integer;
begin
  oldIndex := Printers.Printer.PrinterIndex;
  Result := Printers.Printer.Printers.IndexOf(vclPrinterName);
  if Result < 0 then
    Result := oldIndex;  // Revert to original setting that worked.
  Printers.Printer.PrinterIndex := Result;
end;

function ShellSetDefaultPrinter(PrinterIndex: integer; Wait: Boolean = True)
  : Boolean; overload;
const
  CPARAMS = 'printui.dll,PrintUIEntry /y /q /n"@"';
var
  myParams: string;
  aStr: string;
begin
  Result := False; // rundll32 printui.dll,PrintUIEntry /y /q /n"printername"
  if (PrinterIndex >= 0) and (PrinterIndex < printer.Printers.count) then
  begin
    aStr := printer.Printers[PrinterIndex];
    myParams := ReplaceString(CPARAMS, '@', aStr);
    ShellExecute_AndWait('rundll32', myParams);
    Result := True;
  end;
end;

function ShellSetDefaultPrinter(PrinterName: string; Wait: Boolean = True)
  : Boolean; overload;
var
  i: integer;
begin
  Result := False;
  i := printer.Printers.IndexOf(PrinterName);
  if i >= 0 then
  begin
    ShellSetDefaultPrinter(i, Wait);
    Result := True;
  end;
end;

function GetSetDefaultPrinter(newPrinterName: string): string;
var
  i: integer;
begin
  Result := GetDefaultPrinter; // Name;
  try
    if Result = newPrinterName then
      exit;

    if (newPrinterName > '') and InPrinterList(newPrinterName) then
    begin
      ShellSetDefaultPrinter(newPrinterName);
      for i := 1 to 5 do
      begin
        Application.ProcessMessages;
        Result := GetDefaultPrinter;
        if Result = newPrinterName then
          Break
        else
          sleep(500);
      end;
    end;
  except

  end;
end;

function CaptureConsoleOutput(const ACommand, AParameters: String) : string;
 const
   CReadBuffer = 2400;
 var
   saSecurity: TSecurityAttributes;
   hRead: THandle;
   hWrite: THandle;
   suiStartup: TStartupInfo;
   piProcess: TProcessInformation;
   pBuffer: array[0..CReadBuffer] of AnsiChar;//      <----- update
   dRead: DWord;
   dRunning: DWord;
 begin
   saSecurity.nLength := SizeOf(TSecurityAttributes);
   saSecurity.bInheritHandle := True;
   saSecurity.lpSecurityDescriptor := nil;

   if CreatePipe(hRead, hWrite, @saSecurity, 0) then
   begin
     FillChar(suiStartup, SizeOf(TStartupInfo), #0);
     suiStartup.cb := SizeOf(TStartupInfo);
     suiStartup.hStdInput := hRead;
     suiStartup.hStdOutput := hWrite;
     suiStartup.hStdError := hWrite;
     suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
     suiStartup.wShowWindow := SW_HIDE;

     if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), @saSecurity,
       @saSecurity, True, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup, piProcess)
       then
     begin
       repeat
         dRunning  := WaitForSingleObject(piProcess.hProcess, 100);
         Application.ProcessMessages();
         repeat
           dRead := 0;
           ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
           pBuffer[dRead] := #0;

           OemToAnsi(pBuffer, pBuffer);
           Result := String(pBuffer);
         until (dRead < CReadBuffer);
       until (dRunning <> WAIT_TIMEOUT);
       CloseHandle(piProcess.hProcess);
       CloseHandle(piProcess.hThread);
     end;

     CloseHandle(hRead);
     CloseHandle(hWrite);
   end;
end;

function CreateShortcut(Path, Description: string) : Boolean;
// "Path" might be c:\dc305\dcwin.exe
Var
  IObject: IUnknown;
  ISLink: IShellLink;
  IPFile: IPersistFile;
  PIDL: PItemIDList;
  InFolder: array [0 .. MAX_PATH] of Char;
  TargetName: String;
  LinkName: WideString;

Begin
  try
    // TargetName :='C:\WINDOWS\System32\calc.exe'; //use complete path to desired target
    TargetName := Path; // use complete path to desired target
    // Calc.exe is in other path in Windows 98, check.
    IObject := CreateComObject(CLSID_ShellLink);
    ISLink := IObject as IShellLink;
    IPFile := IObject as IPersistFile;

    with ISLink do begin
      SetPath(pChar(TargetName));
      SetWorkingDirectory(pChar(ExtractFilePath(TargetName)));
    end;

    // if we want to place a link on the Desktop , this function
    // returns the path of the desktop of the current user in Win XP
    SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL);
    SHGetPathFromIDList(PIDL, InFolder);
    // Of course, we can create the link in other path.

    Description := '\' + Description + '.lnk';
    LinkName := InFolder + Description;
    // '\oops.lnk'; // {+ Description} + '.lnk';//Absolute path and name of the new .lnk file
    // The user only sees "My Calculator Link" as the label of the shortcut.

    // Bugz 9301, duplicate shortcuts
    if FileExists(LinkName) then
      DeleteFile(LinkName);

    IPFile.Save(PWChar(LinkName), false);
    // here the new link is created: a new file
    // named "My Calculator Link.lnk" is created in the user's desktop directory.
    Result := FileExists(LinkName);
  except
    Result := False;
  end;
End;

function IsInFiftyStates(aStateStr: string): Boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to 49 do
    if aStateStr = ArrayFiftyStates[i, 1] then
      Result := True;
end;

function Coalesce(Values: array of string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Length(Values) - 1 do
    if (Values[i] > '') then begin
      Result := Values[i];
      Break;
    end;
end;

{ THugeSet }

procedure THugeSet.Add(const items: array of Word);
var
  i: Word;
begin
  for i := 0 to High(items) do
    Add(items[i]);
end;

function THugeSet.IsEmpty: Boolean;
var
  I: Word;
begin
  Result := True;
  for I := 0 to High(Values) do
    if Values[I] > 0 then begin
      Result := false;
      Break;
    end;
end;

function THugeSet.AllSet: Boolean;
var
  I: Word;
begin
  Result := True;
  for I := 0 to High(Values) do
    if Values[i] < $FFFF then begin
      Result := false;
      Break;
    end;
end;

procedure THugeSet.Clear;
begin
  FillChar(Values, SizeOf(Values), 0);
end;

procedure THugeSet.SetAll;
begin
  FillChar(Values, SizeOf(Values), $FF);
end;

procedure THugeSet.Add(n: Word);
var
  i: Word;
begin
  i := n div 16;
  Values[i] := Values[i] or Mask[n and 15];
end;

procedure THugeSet.Del(n: Word);
var
  i: Word;
begin
  i := n div 16;
  Values[i] := Values[i] and not Mask[n and 15];
end;

procedure THugeSet.Del(const items: array of Word);
var
  i: Word;
begin
  for i := 0 to High(items) do
    Del(items[i]);
end;

procedure THugeSet.SetValue(n: Word; const Value: Boolean);
begin
  if Value then
    Add(n)
  else
    Del(n);
end;

function THugeSet.GetValue(n: Word): Boolean;
begin
  Result := InSet(n);
end;

function THugeSet.InSet(n: Word): Boolean;
begin
  Result := Values[n div 16] and Mask[n and 15] <> 0;
end;

procedure EnableAWindow(winHandle: HWND; enableIt : boolean);
begin
  if winHandle <> 0 then
    EnableWindow(winHandle, enableIt);
end;

function TouchFile(filename: string; myDateTime : TDateTime): boolean;
var
  oldFileDate, newFileDate,
  err    : Integer;
  newDateTime : TDateTime;
begin
  oldFileDate := FileAge(fileName);
  newDateTime := myDateTime;
  newFileDate := DateTimeToFileDate(newDateTime);
  err := sysutils.FileSetDate(fileName, newFileDate);

  Result := (err = 0) and (newFileDate = FileAge(fileName));
end;


initialization

InitializeKeyboardKeys;

end.
