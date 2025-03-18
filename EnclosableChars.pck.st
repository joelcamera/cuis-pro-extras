'From Cuis7.3 [latest update: #7079] on 18 March 2025 at 7:25:37 pm'!
'Description '!
!provides: 'EnclosableChars' 1 8!
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

!BracketsTest methodsFor: 'exercising' stamp: 'JEC 3/15/2025 17:26:20'!
keyboardEventWithAngleBracket

	^ self keyboardEventWithCharacter: $<! !

!BracketsTest methodsFor: 'exercising' stamp: 'JEC 3/18/2025 18:40:16'!
keyboardEventWithBracket

	^ self keyboardEventWithCharacter: $(! !

!BracketsTest methodsFor: 'exercising' stamp: 'JEC 3/18/2025 18:41:12'!
keyboardEventWithCurlyBrackets
	
	^ self keyboardEventWithCharacter: ${! !

!BracketsTest methodsFor: 'exercising' stamp: 'JEC 3/18/2025 18:40:28'!
keyboardEventWithSquareBrackets
	
	^ self keyboardEventWithCharacter: $[! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 18:43:28'!
test001_WithoutSelectedTestAddsJustOneAngleBracket

	self
		assertThatWithThisString: '' 
		cursorInIndex: 1
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

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:21:36'!
test003_AddsEnclosableBracketsInEmptyStrings

	self
		assertThatWithThisString: '' 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBracket
		textWillEquals: '()'.
	
	self
		assertThatWithThisString: '' 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: '[]'.
		
	self
		assertThatWithThisString: '' 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: '{}'.! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:22:00'!
test004_ToTheRightOfACharacterAddsEnclosableBrackets

	self
		assertThatWithThisString: 'a' 
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBracket
		textWillEquals: 'a()'.
	
	self
		assertThatWithThisString: 'a' 
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: 'a[]'.
		
	self
		assertThatWithThisString: 'a' 
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: 'a{}'.! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:22:30'!
test005_ToTheLeftOfACharacter_AddsOpenningBracket

	self
		assertThatWithThisString: 'a' 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBracket
		textWillEquals: '(a'.
	
	self
		assertThatWithThisString: 'a' 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: '[a'.
		
	self
		assertThatWithThisString: 'a' 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: '{a'.! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:22:51'!
test006_WithSpaceToTheRight_AddsEnclosableBrackets

	self
		assertThatWithThisString: ' '
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBracket
		textWillEquals: '() '.
	
	self
		assertThatWithThisString: ' '
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: '[] '.
		
	self
		assertThatWithThisString: ' '
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: '{} '.! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:23:09'!
test007_WithSpaceToTheLeft_AddsEnclosableCharacters

	self
		assertThatWithThisString: ' '
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBracket
		textWillEquals: ' ()'.
	
	self
		assertThatWithThisString: ' '
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: ' []'.
		
	self
		assertThatWithThisString: ' '
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: ' {}'.! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:23:52'!
test008_WithTabToTheLeft_AddsEnclosableBrackets

	self
		assertThatWithThisString: '	'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBracket
		textWillEquals: '	()'.
	
	self
		assertThatWithThisString: '	'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: '	[]'.
		
	self
		assertThatWithThisString: '	'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: '	{}'.! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:23:45'!
test009_WithTabToTheRight_AddsEnclosableBrackets

	self
		assertThatWithThisString: '	'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBracket
		textWillEquals: '()	'.
	
	self
		assertThatWithThisString: '	'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: '[]	'.
		
	self
		assertThatWithThisString: '	'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: '{}	'.! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:24:13'!
test010_WithNewLineToTheLeft_AddsEnclosableBrackets

	self
		assertThatWithThisString: '
'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBracket
		textWillEquals: '
()'.
	
	self
		assertThatWithThisString: '
'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: '
[]'.
		
	self
		assertThatWithThisString: '
'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: '
{}'.! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:24:27'!
test011_WithNewLineToTheRight_AddsEnclosableBrackets

	self
		assertThatWithThisString: '()'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBracket
		textWillEquals: '(())'.
	
	self
		assertThatWithThisString: '[]'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: '[[]]'.
		
	self
		assertThatWithThisString: '{}'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: '{{}}'.! !

!BracketsTest methodsFor: 'tests-angle bracket' stamp: 'JEC 3/18/2025 19:24:54'!
test012_WhenStringIsSelected_EncloseTheSelectionWithBrackets

	self
		assertThatWithThisString: 'asdf' 
		selectedTextFromIndex: 1
		selectedTextToIndex: 5
		whenKeyboardEventAppears: self keyboardEventWithBracket 
		textWillEquals: '(asdf)'.
	self assert: editor selectedString equals: 'asdf'.
	
	self
		assertThatWithThisString: 'asdf'
		selectedTextFromIndex: 1
		selectedTextToIndex: 5
		whenKeyboardEventAppears: self keyboardEventWithSquareBrackets
		textWillEquals: '[asdf]'.
	self assert: editor selectedString equals: 'asdf'.
		
	self
		assertThatWithThisString: 'asdf'
		selectedTextFromIndex: 1
		selectedTextToIndex: 5
		whenKeyboardEventAppears: self keyboardEventWithCurlyBrackets
		textWillEquals: '{asdf}'.
	self assert: editor selectedString equals: 'asdf'.! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 17:28:34'!
assertThatWithThisString: aStartingString cursorInIndex: aCursorIndex whenKeyboardEventAppears: aKeyboardEvent textWillEquals: anExpectedText

	self setUpWithString: aStartingString.
	editor pointIndex: aCursorIndex .

	editor enclosableQuotationMarks: aKeyboardEvent.
	
	self assert: model actualContents equals: anExpectedText.! !

!QuotationMarksTest methodsFor: 'assertions' stamp: 'JEC 3/15/2025 17:28:42'!
assertThatWithThisString: aStartingString selectedTextFromIndex: aStartIndex  selectedTextToIndex: aStopIndex whenKeyboardEventAppears: aKeyboardEvent textWillEquals: anExpectedText

	self setUpWithString: aStartingString.
	editor markIndex: aStartIndex pointIndex: aStopIndex.

	editor enclosableQuotationMarks: aKeyboardEvent.
	
	self assert: model actualContents equals: anExpectedText.! !

!QuotationMarksTest methodsFor: 'exercising' stamp: 'JEC 3/15/2025 16:13:05'!
keyboardEventWithBacktick

	^ self keyboardEventWithCharacter: $`! !

!QuotationMarksTest methodsFor: 'exercising' stamp: 'JEC 3/15/2025 15:11:10'!
keyboardEventWithDoubleQuotes.
	
	^ self keyboardEventWithCharacter: $"! !

!QuotationMarksTest methodsFor: 'exercising' stamp: 'JEC 3/15/2025 15:12:21'!
keyboardEventWithSingleQuote
	
	^ self keyboardEventWithCharacter: $'! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:31:54'!
test001_EncloseWhenThereIsNoOtherCharacters

	self
		assertThatWithThisString: '' 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes
		textWillEquals: '""'.
		
	self
		assertThatWithThisString: '' 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: ''''''.
	
	self
		assertThatWithThisString: '' 
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: '``'! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:32:49'!
test002_WithACharacterToTheLeft_AddsOneQuotationMark

	self 
		assertThatWithThisString: 'a'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: 'a"'.
	
	self 
		assertThatWithThisString: 'a'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: 'a'''
.
	
	self 
		assertThatWithThisString: 'a'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: 'a`'! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:32:49'!
test003_WithACharacterToTheRight_AddsOneQuotationMark

	self 
		assertThatWithThisString: 'a'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: '"a'.
	
	self 
		assertThatWithThisString: 'a'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: '''a'
.
	
	self 
		assertThatWithThisString: 'a'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: '`a'! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:32:49'!
test004_WithASpaceToTheRight_AddsTwoQuotationMarks
	
	self 
		assertThatWithThisString: ' '
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: '"" '.
	
	self 
		assertThatWithThisString: ' '
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: ''''' '
.
		
	self 
		assertThatWithThisString: ' '
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: '`` '! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:32:49'!
test005_WithASpaceToTheLeft_AddsTwoQuotationMarks
	
	self 
		assertThatWithThisString: ' '
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: ' ""'.
	
	self 
		assertThatWithThisString: ' '
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: ' '''''
.
		
	self 
		assertThatWithThisString: ' '
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: ' ``'.! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:32:49'!
test006_WithATabToTheLeft_AddsTwoQuotationMarks

	self 
		assertThatWithThisString: '	'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: '	""'.
		
	self 
		assertThatWithThisString: '	'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: '	'''''
.
		
	self 
		assertThatWithThisString: '	'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: '	``'! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:32:49'!
test007_WithATabToTheRight_AddsTwoQuotationMarks

	self 
		assertThatWithThisString: '	'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: '""	'.
	
	self 
		assertThatWithThisString: '	'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: '''''	'
.
	
	self 
		assertThatWithThisString: '	'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: '``	'! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:32:49'!
test008_WithANewLineToTheLeft_AddsTwoQuotationMarks

	self 
		assertThatWithThisString: '
'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: '
""'.

	self 
		assertThatWithThisString: '
'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: '
'''''
.

	self 
		assertThatWithThisString: '
'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: '
``'! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:32:49'!
test009_WithANewLineToTheRight_AddsTwoQuotationMarks

	self 
		assertThatWithThisString: '
'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: '""
'.

	self 
		assertThatWithThisString: '
'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: '''''
'
.

	self 
		assertThatWithThisString: '
'
		cursorInIndex: 1
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: '``
'! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:33:20'!
test010_EnclosedWithSameQuotationMarks_MovesTheCursorToTheRight
	
	self 
		assertThatWithThisString: '""'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: '""'.
	self assert: editor stopIndex equals: 3.
	
	self 
		assertThatWithThisString: ''''''
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: ''''''.
	self assert: editor stopIndex equals: 3.
	
	self 
		assertThatWithThisString: '``'
		cursorInIndex: 2
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: '``'.
	self assert: editor stopIndex equals: 3.! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:34:10'!
test011_WhenThereisSelectedCode_EncloseTheSelectedCodeWithQuotationMarks
	
	self 
		assertThatWithThisString: 'asdf'
		selectedTextFromIndex:  1
		selectedTextToIndex: 5
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes
		textWillEquals: '"asdf"' .
	self assert: editor selectedString equals: 'asdf'.
	
	self 
		assertThatWithThisString: 'asdf'
		selectedTextFromIndex:  1
		selectedTextToIndex: 5
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote 
		textWillEquals: '''asdf''' .
	self assert: editor selectedString equals: 'asdf'.
	
	self 
		assertThatWithThisString: 'asdf'
		selectedTextFromIndex:  1
		selectedTextToIndex: 5
		whenKeyboardEventAppears: self keyboardEventWithBacktick
		textWillEquals: '`asdf`' .
	self assert: editor selectedString equals: 'asdf'! !

!QuotationMarksTest methodsFor: 'tests' stamp: 'JEC 3/18/2025 18:32:49'!
test012_AddsOneQuotationMark_WhenThereAreCharactersToTheLeftOfEnclosingQuotationMark
	
	self 
		assertThatWithThisString: 'a""'
		cursorInIndex: 3
		whenKeyboardEventAppears: self keyboardEventWithDoubleQuotes 
		textWillEquals: 'a"""'.
	self assert: editor stopIndex equals: 4.
	
	self 
		assertThatWithThisString: 'a'''''
		cursorInIndex: 3
		whenKeyboardEventAppears: self keyboardEventWithSingleQuote
		textWillEquals: 'a'''''''
.
	self assert: editor stopIndex equals: 4.
	
	self 
		assertThatWithThisString: 'a``'
		cursorInIndex: 3
		whenKeyboardEventAppears: self keyboardEventWithBacktick 
		textWillEquals: 'a```'.
	self assert: editor stopIndex equals: 4.! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/15/2025 17:09:07'!
characterAt: anIndex equals: aCharacter

	| char |
	char := model actualContents at: anIndex ifAbsent: [ ^false ].

	^ char = aCharacter! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/18/2025 18:50:53'!
characterAtIsNotClosableChar: anIndex

	| char |
	char := model actualContents at: anIndex ifAbsent: [ ^false ].

	^ self isNotClosableChar: char.! !

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

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/18/2025 19:00:24'!
notExistsCharacterAt: anIndex

	model actualContents at: anIndex ifAbsent: [ ^true ].
	
	^ false! !

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

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/18/2025 19:15:41'!
shouldAddJustOneEnclosableChar

	"If there is no selected string and there is another character to the left or to the right that is not empty this answers true"

	| index contents |
	
	"The selection must be empty, and in this case self stopIndex is equals to self startIndex"
	index := self stopIndex.
	contents := model actualContents.
	
	^ (self selection isEmpty 
		and: [ (self notExistsCharacterAt: index - 1)  or: [ self characterAtIsNotEmpty: index - 1 ] ]
		and: [ (self notExistsCharacterAt: index) or: [ self characterAtIsNotEmpty: index ] ]
		and: [ self characterAtIsNotClosableChar: index ]) "Is always pointing the next"! !

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
