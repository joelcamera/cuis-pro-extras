'From Cuis7.3 [latest update: #7070] on 15 March 2025 at 5:38:31 pm'!
'Description '!
!provides: 'EnclosableChars' 1 6!
SystemOrganization addCategory: #EnclosableChars!


!classDefinition: #EnclosableCharsTest category: #EnclosableChars!
TestCase subclass: #EnclosableCharsTest
	instanceVariableNames: 'model editor iTextMorph txtComposition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'EnclosableChars'!
!classDefinition: 'EnclosableCharsTest class' category: #EnclosableChars!
EnclosableCharsTest class
	instanceVariableNames: ''!

!classDefinition: #BracketsTest category: #EnclosableChars!
EnclosableCharsTest subclass: #BracketsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'EnclosableChars'!
!classDefinition: 'BracketsTest class' category: #EnclosableChars!
BracketsTest class
	instanceVariableNames: ''!

!classDefinition: #QuotationMarksTest category: #EnclosableChars!
EnclosableCharsTest subclass: #QuotationMarksTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'EnclosableChars'!
!classDefinition: 'QuotationMarksTest class' category: #EnclosableChars!
QuotationMarksTest class
	instanceVariableNames: ''!


!EnclosableCharsTest methodsFor: 'setUp/tearDown' stamp: 'JEC 3/15/2025 16:25:04'!
setUpWithString: aString

	model := TextModel withText: aString copy.
	editor := TextEditor new.
	iTextMorph := InnerTextMorph new.
	iTextMorph privateOwner: TextModelMorph new.
	iTextMorph model: model.
	editor morph: iTextMorph.
	editor instVarNamed: 'emphasisHere' put: Array new.
	editor model: model.
	iTextMorph installEditorAndTextComposition.
	txtComposition := TextComposition new.
	txtComposition
		setModel: model;
		extentForComposing: 300@300.
	editor textComposition: txtComposition.
	txtComposition editor: editor.
	txtComposition composeAll.! !

!EnclosableCharsTest methodsFor: 'exercising' stamp: 'JEC 3/15/2025 16:26:04'!
keyboardEventWithCharacter: aCharacter
	
	^ KeyboardEvent new
		setType: #keystroke
		buttons: 0
		position: 0@0
		keyValue: aCharacter asciiValue 
		hand: UISupervisor ui activeHand
		stamp: 0! !

!BracketsTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 17:29:56'!
assertThatWithThisString: aStartingString cursorInIndex: aCursorIndex whenKeyboardEventAppears: aKeyboardEvent textWillEquals: anExpectedText

	self setUpWithString: aStartingString.
	editor pointIndex: aCursorIndex.

	editor enclosableBrackets: aKeyboardEvent.
	
	self assert: model actualContents equals: anExpectedText.! !

!BracketsTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 17:32:22'!
assertThatWithThisString: aStartingString selectedTextFromIndex: aStartIndex  selectedTextToIndex: aStopIndex whenKeyboardEventAppears: aKeyboardEvent textWillEquals: anExpectedText

	self setUpWithString: aStartingString.
	editor markIndex: aStartIndex pointIndex: aStopIndex.

	editor enclosableBrackets: aKeyboardEvent.
	
	self assert: model actualContents equals: anExpectedText.! !

!BracketsTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 17:31:08'!
assertThatWithThisString: aStartingString whenKeyboardEventAppears: aKeyboardEvent textWillEquals: anExpectedText
	
	self
		assertThatWithThisString: aStartingString 
		cursorInIndex: 1
		whenKeyboardEventAppears: aKeyboardEvent
		textWillEquals: anExpectedText! !

!BracketsTest methodsFor: 'exercising' stamp: 'JEC 3/15/2025 17:26:20'!
keyboardEventWithAngleBracket

	^ self keyboardEventWithCharacter: $<! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/15/2025 17:34:32'!
test001_WithoutSelectedTestAddsJustOneAngleBracket

	self 
		assertThatWithThisString: '' 
		whenKeyboardEventAppears: self keyboardEventWithAngleBracket
		textWillEquals: '<'! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/15/2025 17:34:22'!
test002_WithSelectedTestEncloseItWithAngleBrackets

	self 
		assertThatWithThisString: 'asdf'
		selectedTextFromIndex: 1
		selectedTextToIndex: 5
		whenKeyboardEventAppears: self keyboardEventWithAngleBracket 
		textWillEquals: '<asdf>'.
	
	self assert: editor selectedString equals: 'asdf'! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 16:15:14'!
assertThatWithThisString: aStartingString cursorInIndex: aCursorIndex whenBacktickKeyboardEventAppearsTextWillEquals: anExpectedText 
	
	self 
		assertThatWithThisString: aStartingString
		cursorInIndex: aCursorIndex
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: anExpectedText! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 15:48:48'!
assertThatWithThisString: aStartingString cursorInIndex: aCursorIndex whenDoubleQuoteKeyboardEventAppearsTextWillEquals: anExpectedText

	self 
		assertThatWithThisString: aStartingString
		cursorInIndex: aCursorIndex
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: anExpectedText! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 17:28:34'!
assertThatWithThisString: aStartingString cursorInIndex: aCursorIndex whenKeyboardEventAppears: aKeyboardEvent textWillEquals: anExpectedText

	self setUpWithString: aStartingString.
	editor pointIndex: aCursorIndex .

	editor enclosableQuotationMarks: aKeyboardEvent.
	
	self assert: model actualContents equals: anExpectedText.! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 15:48:29'!
assertThatWithThisString: aStartingString cursorInIndex: aCursorIndex whenSingleQuoteKeyboardEventAppearsTextWillEquals: anExpectedText

	self 
		assertThatWithThisString: aStartingString
		cursorInIndex: aCursorIndex
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: anExpectedText
! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 16:21:12'!
assertThatWithThisString: aStartingString selectedTextFromIndex: aStartIndex selectedTextToIndex: aStopIndex whenBacktickKeyboardEventAppearsTextWillEquals: anExpectedText 

	self 
		assertThatWithThisString: aStartingString
		selectedTextFromIndex:  aStartIndex
		selectedTextToIndex: aStopIndex
		whenKeyboardEventAppears: self keyboardEventWithBacktick
		textWillEquals: anExpectedText ! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 15:59:47'!
assertThatWithThisString:  aStartingString selectedTextFromIndex: aStartIndex selectedTextToIndex: aStopIndex whenDoubleQuoteKeyboardEventAppearsTextWillEquals: anExpectedText

	self 
		assertThatWithThisString: aStartingString
		selectedTextFromIndex:  aStartIndex
		selectedTextToIndex: aStopIndex
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes
		textWillEquals: anExpectedText ! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 17:28:42'!
assertThatWithThisString: aStartingString selectedTextFromIndex: aStartIndex  selectedTextToIndex: aStopIndex whenKeyboardEventAppears: aKeyboardEvent textWillEquals: anExpectedText

	self setUpWithString: aStartingString.
	editor markIndex: aStartIndex pointIndex: aStopIndex.

	editor enclosableQuotationMarks: aKeyboardEvent.
	
	self assert: model actualContents equals: anExpectedText.! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 15:59:59'!
assertThatWithThisString:  aStartingString selectedTextFromIndex: aStartIndex selectedTextToIndex: aStopIndex whenSingleQuoteKeyboardEventAppearsTextWillEquals: anExpectedText

	self 
		assertThatWithThisString: aStartingString
		selectedTextFromIndex:  aStartIndex
		selectedTextToIndex: aStopIndex
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote 
		textWillEquals: anExpectedText ! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 16:12:37'!
assertThatWithThisString: aStartingString whenBacktickKeyboardEventAppearsTextWillEquals: anExpectedText 

	self
		assertThatWithThisString: aStartingString 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: anExpectedText! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 15:46:50'!
assertThatWithThisString: aStartingString whenDoubleQuoteKeyboardEventAppearsTextWillEquals: anExpectedText
	
	self
		assertThatWithThisString: aStartingString 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: anExpectedText! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 17:28:51'!
assertThatWithThisString: aStartingString whenKeyboardEventAppears: aKeyboardEvent textWillEquals: anExpectedText
	
	self
		assertThatWithThisString: aStartingString 
		cursorInIndex: 1
		whenKeyboardEventAppears: aKeyboardEvent
		textWillEquals: anExpectedText! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 15:47:05'!
assertThatWithThisString: aStartingString whenSingleQuoteKeyboardEventAppearsTextWillEquals: anExpectedText
	
	self
		assertThatWithThisString: aStartingString 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: anExpectedText! !

!QuotationMarksTest methodsFor: 'exercising' stamp: 'JEC 3/15/2025 16:13:05'!
keyboardEventWithBacktick

	^ self keyboardEventWithCharacter: $`! !

!QuotationMarksTest methodsFor: 'exercising' stamp: 'JEC 3/15/2025 15:11:10'!
keyboardEventWithDoubleQuotes.
	
	^ self keyboardEventWithCharacter: $"! !

!QuotationMarksTest methodsFor: 'exercising' stamp: 'JEC 3/15/2025 15:12:21'!
keyboardEventWithSingleQuote
	
	^ self keyboardEventWithCharacter: $'! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:13:22'!
test023_EncloseWithBacktickWhenThereIsNoOtherCharacters

	self
		assertThatWithThisString: '' 
		whenBacktickKeyboardEventAppearsTextWillEquals: '``'
! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:13:59'!
test024_WithACharacterToTheLeft_AddsOneBacktick
	
	self 
		assertThatWithThisString: 'a' 
		cursorInIndex: 2 
		whenBacktickKeyboardEventAppearsTextWillEquals: 'a`'! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:17:37'!
test025_WithACharacterToTheRight_AddsOneBacktick

	self 
		assertThatWithThisString: 'a' 
		cursorInIndex: 1
		whenBacktickKeyboardEventAppearsTextWillEquals: '`a'! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:16:16'!
test026_WithASpaceToTheRight_AddsTwoBackticks
	
	self 
		assertThatWithThisString: ' ' 
		cursorInIndex: 1
		whenBacktickKeyboardEventAppearsTextWillEquals: '`` '! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:18:03'!
test027_WithASpaceToTheLeft_AddsTwoBackticks
	
	self 
		assertThatWithThisString: ' ' 
		cursorInIndex: 2
		whenBacktickKeyboardEventAppearsTextWillEquals: ' ``'! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:18:24'!
test028_WithATabToTheLeft_AddsTwoBackticks
	
	self 
		assertThatWithThisString: '	' 
		cursorInIndex: 2
		whenBacktickKeyboardEventAppearsTextWillEquals: '	``'! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:18:44'!
test029_WithATabToTheRight_AddsTwoBackticks

	self 
		assertThatWithThisString: '	' 
		cursorInIndex: 1
		whenBacktickKeyboardEventAppearsTextWillEquals: '``	'! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:19:03'!
test030_WithANewLineToTheLeft_AddsTwoBacktick

	self 
		assertThatWithThisString: '
' 
		cursorInIndex: 2
		whenBacktickKeyboardEventAppearsTextWillEquals: '
``'! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:19:25'!
test031_WithANewLineToTheRight_AddsTwoBackticks

	self 
		assertThatWithThisString: '
'
		cursorInIndex: 1
		whenBacktickKeyboardEventAppearsTextWillEquals: '``
'! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:20:00'!
test032_EnclosedWithBackticks_MovesTheCursorToTheRight
	
	self 
		assertThatWithThisString: '``'
		cursorInIndex: 2
		whenBacktickKeyboardEventAppearsTextWillEquals: '``'.
		
	self assert: editor stopIndex equals: 3.! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 16:21:34'!
test033_WhenThereisSelectedCode_EncloseTheSelectedCodeWithBackticks

	self 
		assertThatWithThisString: 'asdf'
		selectedTextFromIndex: 1
		selectedTextToIndex: 5
		whenBacktickKeyboardEventAppearsTextWillEquals: '`asdf`'.
	
	self assert: editor selectedString equals: 'asdf'! !

!QuotationMarksTest methodsFor: 'tests-backtick' stamp: 'JEC 3/15/2025 17:15:02'!
test036_AddsOneBacktick_WhenThereAreCharactersToTheLeftOfEnclosingBacktick
	
	self 
		assertThatWithThisString: 'a``'
		cursorInIndex: 3 
		whenBacktickKeyboardEventAppearsTextWillEquals: 'a```'.
	
	self assert: editor stopIndex equals: 4.! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:44:55'!
test001_EncloseWithDoubleQuotesWhenThereIsNoOtherCharacters

	self 
		assertThatWithThisString: ''
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes
		textWillEquals: '""'! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:50:18'!
test002_WithACharacterToTheLeft_AddsOneDoubleQuote

	self 
		assertThatWithThisString: 'a' 
		cursorInIndex: 2 
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: 'a"'! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:50:49'!
test003_WithACharacterToTheRight_AddsOneDoubleQuote

	self 
		assertThatWithThisString: 'a' 
		cursorInIndex: 1
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: '"a'! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:51:08'!
test004_WithASpaceToTheRight_AddsTwoDoubleQuote
	
	self 
		assertThatWithThisString: ' ' 
		cursorInIndex: 1
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: '"" '! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:51:27'!
test005_WithASpaceToTheLeft_AddsTwoDoubleQuote
	
	self 
		assertThatWithThisString: ' ' 
		cursorInIndex: 2
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: ' ""'! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:51:52'!
test006_WithATabToTheLeft_AddsTwoDoubleQuote

	self 
		assertThatWithThisString: '	' 
		cursorInIndex: 2
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: '	""'! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:52:23'!
test007_WithATabToTheRight_AddsTwoDoubleQuote

	self 
		assertThatWithThisString: '	' 
		cursorInIndex: 1
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: '""	'! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:53:02'!
test008_WithANewLineToTheLeft_AddsTwoDoubleQuote

	self 
		assertThatWithThisString: '
' 
		cursorInIndex: 2
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: '
""'! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:53:34'!
test009_WithANewLineToTheRight_AddsTwoDoubleQuote

	self 
		assertThatWithThisString: '
' 
		cursorInIndex: 1
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: '""
'! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 15:54:29'!
test010_EnclosedWithDoubleQuotes_MovesTheCursorToTheRight
	
	self 
		assertThatWithThisString:  '""'
		cursorInIndex: 2
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: '""'.
	
	self assert: editor stopIndex equals: 3.! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 16:21:49'!
test011_WhenThereisSelectedCode_EncloseTheSelectedCodeWithDoubleQuotes
	
	self 
		assertThatWithThisString:  'asdf'
		selectedTextFromIndex: 1
		selectedTextToIndex: 5
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: '"asdf"'.
	
	self assert: editor selectedString equals: 'asdf'! !

!QuotationMarksTest methodsFor: 'tests-double quotes' stamp: 'JEC 3/15/2025 16:57:10'!
test034_AddsOneDoubleQuote_WhenThereAreCharactersToTheLeftOfEnclosingDoubleQuote
	
	self 
		assertThatWithThisString: 'a""'
		cursorInIndex: 3 
		whenDoubleQuoteKeyboardEventAppearsTextWillEquals: 'a"""'.
	
	self assert: editor stopIndex equals: 4.! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:01:05'!
test012_EncloseWithSingleQuoteWhenThereIsNoOtherCharacters

	self
		assertThatWithThisString: '' 
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: ''''''
! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:01:41'!
test013_WithACharacterToTheLeft_AddsOneSingleQuote
	
	self 
		assertThatWithThisString: 'a' 
		cursorInIndex: 2 
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: 'a'''! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:02:37'!
test014_WithACharacterToTheRight_AddsOneSingleQuote

	self 
		assertThatWithThisString: 'a' 
		cursorInIndex: 1
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: '''a'! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:03:28'!
test015_WithASpaceToTheRight_AddsTwoSingleQuote
	
	self 
		assertThatWithThisString: ' ' 
		cursorInIndex: 1
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: ''''' '! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:04:00'!
test016_WithASpaceToTheLeft_AddsTwoSingleQuote
	
	self 
		assertThatWithThisString: ' ' 
		cursorInIndex: 2
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: ' '''''! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:04:37'!
test017_WithATabToTheLeft_AddsTwoSingleQuote
	
	self 
		assertThatWithThisString: '	' 
		cursorInIndex: 2
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: '	'''''! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:05:11'!
test018_WithATabToTheRight_AddsTwoSingleQuote

	self 
		assertThatWithThisString: '	' 
		cursorInIndex: 1
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: '''''	'! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:06:13'!
test019_WithANewLineToTheLeft_AddsTwoSingleQuote

	self 
		assertThatWithThisString: '
' 
		cursorInIndex: 2
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: '
'''''! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:06:54'!
test020_WithANewLineToTheRight_AddsTwoSingleQuote

	self 
		assertThatWithThisString: '
'
		cursorInIndex: 1
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: '''''
'! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:07:45'!
test021_EnclosedWithSingleQuotes_MovesTheCursorToTheRight
	
	self 
		assertThatWithThisString: ''''''
		cursorInIndex: 2
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: ''''''.
		
	self assert: editor stopIndex equals: 3.! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 16:09:30'!
test022_WhenThereisSelectedCode_EncloseTheSelectedCodeWithSingleQuotes

	self 
		assertThatWithThisString: 'asdf'
		selectedTextFromIndex: 1
		selectedTextToIndex: 5
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: '''asdf'''.
	
	self assert: editor selectedString equals: 'asdf'! !

!QuotationMarksTest methodsFor: 'tests-single quotes' stamp: 'JEC 3/15/2025 17:14:30'!
test035_AddsOneSingleQuote_WhenThereAreCharactersToTheLeftOfEnclosingSingleQuote
	
	self 
		assertThatWithThisString: 'a'''''
		cursorInIndex: 3 
		whenSingleQuoteKeyboardEventAppearsTextWillEquals: 'a'''''''.
	
	self assert: editor stopIndex equals: 4.! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/15/2025 17:09:07'!
characterAt: anIndex equals: aCharacter

	| char |
	char := model actualContents at: anIndex ifAbsent: [ ^false ].

	^ char = aCharacter! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/15/2025 17:12:18'!
characterAtIsNotEmpty: anIndex

	| char |
	char := model actualContents at: anIndex ifAbsent: [ ^false ].

	^ self isNotEmptyChar: char! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/15/2025 17:18:48'!
enclosableBrackets: aKeyboardEvent 
	"It's not the same as the one in: `encloseWith:`
	This feature behaves more like in IntelliJ or VSCode"

	| left right startIndex stopIndex which |
	startIndex := self startIndex.
	stopIndex := self stopIndex.
	which := '([<{' indexOf: aKeyboardEvent keyCharacter ifAbsent: [ ^true ].
	left := '([<{' at: which.
	right := ')]>}' at: which.

	(left = $<)
		ifTrue: [
			self shouldAddJustOneAngleBracket
				ifTrue: [ self replaceSelectionAddingToTheRight: left ]
				ifFalse: [ self encloseSelectionWithLeftChar: left andRightChar: right ]
		]
		ifFalse: [
			self shouldAddJustOneEnclosableChar
				ifTrue: [ self replaceSelectionAddingToTheLeft: left ]
				ifFalse: [ self encloseSelectionWithLeftChar: left andRightChar: right ].
		].
	
	self selectFrom: startIndex+1 to: stopIndex.

	^ true.! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/15/2025 17:18:41'!
enclosableQuotationMarks: aKeyboardEvent 
	"It's not the same as the one in: `encloseWith:`
	This feature behaves more like in IntelliJ or VSCode"

	| char startIndex stopIndex which |
	startIndex := self startIndex.
	stopIndex := self stopIndex.
	which := '"''`' indexOf: aKeyboardEvent keyCharacter ifAbsent: [ ^true ].
	char := '"''`' at: which.

	(self shouldNotMoveToStopIndex: char)
		ifTrue: [
			self shouldAddJustOneQuotation
				ifTrue: [ self replaceSelectionAddingToTheRight: char ]
				ifFalse: [ self encloseSelectionWithLeftChar: char andRightChar: char ]
		].
	
	self selectFrom: startIndex+1 to: stopIndex.

	^ true.! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 20:05:51'!
encloseSelectionWithLeftChar: aLeftChar andRightChar: aRightChar

	self replaceSelectionWith: 
		(Text string: (UnicodeString with: aLeftChar) attributes: emphasisHere),
		self selection,
		(Text string: (UnicodeString with: aRightChar) attributes: emphasisHere)! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 19:28:00'!
isNotClosableChar: aCharacter

	^ (')]>}' includes: aCharacter) not! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/15/2025 09:39:31'!
isNotEmptyChar: aCharacter

	^ ({ Character space. Character newLineCharacter. Character tab } includes: aCharacter) not! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 20:06:14'!
replaceSelectionAddingToTheLeft: aChar

	self replaceSelectionWith: 
		(Text string: (UnicodeString with: aChar) attributes: emphasisHere),
		self selection! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 20:06:40'!
replaceSelectionAddingToTheRight: aChar

	self replaceSelectionWith: 
		self selection,
		(Text string: (UnicodeString with: aChar) attributes: emphasisHere)! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 20:24:36'!
shouldAddJustOneAngleBracket

	^ self selection isEmpty! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 20:16:46'!
shouldAddJustOneEnclosableChar

	"If there is no selected string and there is another character to the left or to the right that is not empty this answers true"

	| index contents |
	
	"The selection must be empty, and in this case self stopIndex is equals to self startIndex"
	index := self stopIndex.
	contents := model actualContents.
	
	^ (self selection isEmpty 
		and: [ index < (contents size) ]
		and: [ self isNotEmptyChar: (contents at: index+1) ]
		and: [ self isNotClosableChar: (contents at: index) ]) "Is always pointing the next"! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/15/2025 17:18:13'!
shouldAddJustOneQuotation

	"If there is no selected string and there is another character to the left or to the right that is not empty this answers true"

	| index |
	index := self startIndex.

	^ self selection isEmpty 
		and: [ (self characterAtIsNotEmpty: index-1) or: [ self characterAtIsNotEmpty: index ] ]! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/15/2025 17:16:21'!
shouldNotMoveToStopIndex: aQuotationCharacter

	" If there is no selection, and the index is enclosed by aQuotationCharacter, and there are not empty characters around, the pointer should move to the end.
	So, the negation of previous statement is the answer needed."

	| index |
	index := self startIndex.

	^ (self selection isEmpty 
		and: [ self characterAt: index equals: aQuotationCharacter ]
		and: [ self characterAt: index - 1 equals: aQuotationCharacter ]
		and: [ ((self characterAtIsNotEmpty: index - 2 ) or: [ self characterAtIsNotEmpty: index + 1]) not ]
	) not! !

!TextEditor class methodsFor: '*EnclosableChars' stamp: 'JEC 3/15/2025 16:38:59'!
initializeKeyboardActions
	
	super initializeKeyboardActions.
	keyboardActions at: 9 + 1 put: #tabKey:.
	keyboardActions at: 11 + 1 put: #cursorPageUp:.			"page up key"
	keyboardActions at: 12 + 1 put: #cursorPageDown:.		"page down key"
	keyboardActions at: 30 + 1 put: #cursorUp:.				"up arrow key"
	keyboardActions at: 31 + 1 put: #cursorDown:.			"down arrow key"
	
	keyboardActions at: 34 + 1 put: #enclosableQuotationMarks:.  "double quotes"
	keyboardActions at: 39 + 1 put: #enclosableQuotationMarks:.  "single quote ' "
	keyboardActions at: 40 + 1 put: #enclosableBrackets:.  "parenthesis ("
	keyboardActions at: 60 + 1 put: #enclosableBrackets:.  "angle bracket <"
	keyboardActions at: 91 + 1 put: #enclosableBrackets:.  "square bracket ["
	keyboardActions at: 96 + 1 put: #enclosableQuotationMarks:.  "backtick `"
	keyboardActions at: 123 + 1 put: #enclosableBrackets:.  "curly bracket {"! !

Editor initialize!