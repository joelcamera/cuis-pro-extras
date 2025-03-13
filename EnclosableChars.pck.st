'From Cuis7.3 [latest update: #7069] on 13 March 2025 at 8:28:48 pm'!
'Description '!
!provides: 'EnclosableChars' 1 5!



!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 20:26:18'!
enclosableChar: aKeyboardEvent 
	"It's not the same as the one in:
		encloseWith:
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

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 19:45:12'!
enclosableQuotes: aKeyboardEvent 
	"It's not the same as the one in:
		encloseWith:
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

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/12/2025 19:15:55'!
isNotEmptyChar: aCharacter

	^ ({ Character space. Character newLineCharacter } includes: aCharacter) not! !

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

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 20:19:06'!
shouldAddJustOneQuotation

	"If there is no selected string and there is another character to the left or to the right that is not empty this answers true"

	| index contents |
	index := self startIndex.
	contents := model actualContents.

	^ (self selection isEmpty 
		and: [ 
			(index > 1 and: [ self isNotEmptyChar: (contents at: index-1)])
				or: [ index <= (contents size) and: [ self isNotEmptyChar: (contents at: index) ] ]
		])! !

!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 3/13/2025 20:11:47'!
shouldNotMoveToStopIndex: aCharacter

	" If there is no selection, and the index is enclosed by aCharacter, and there are not empty characters around, the pointer shoud move to the end.
	So, the negation of previous statement is the answer needed."

	| index contents |
	index := self startIndex.
	contents := model actualContents.

	^ (self selection isEmpty 
		and: [ index >= 1 and: [ index <= contents size ] and: [  (contents at: index) = aCharacter ] ]
		and: [ index >= 2 and: [ (contents at: index - 1) = aCharacter ] ]
		and: [
			((index > 3 and: [ self isNotEmptyChar: (contents at: index - 2) ])
			or: [ index < (contents size -1) and: [ self isNotEmptyChar: (contents at: index + 1)] ]) 
				not
		]
	) not! !

!TextEditor class methodsFor: '*EnclosableChars' stamp: 'JEC 3/12/2025 08:58:12'!
initializeKeyboardActions
	
	super initializeKeyboardActions.
	keyboardActions at: 9 + 1 put: #tabKey:.
	keyboardActions at: 11 + 1 put: #cursorPageUp:.			"page up key"
	keyboardActions at: 12 + 1 put: #cursorPageDown:.		"page down key"
	keyboardActions at: 30 + 1 put: #cursorUp:.				"up arrow key"
	keyboardActions at: 31 + 1 put: #cursorDown:.			"down arrow key"
	
	keyboardActions at: 34 + 1 put: #enclosableQuotes:.  "double quotes"
	keyboardActions at: 39 + 1 put: #enclosableQuotes:.  "single quote ' "
	keyboardActions at: 40 + 1 put: #enclosableChar:.  "parenthesis ("
	keyboardActions at: 60 + 1 put: #enclosableChar:.  "angle bracket <"
	keyboardActions at: 91 + 1 put: #enclosableChar:.  "square bracket ["
	keyboardActions at: 96 + 1 put: #enclosableQuotes:.  "backtick `"
	keyboardActions at: 123 + 1 put: #enclosableChar:.  "curly bracket {"! !
