'From Cuis7.3 [latest update: #7036] on 22 February 2025 at 11:21:11 pm'!
'Description '!
!provides: 'EnclosableChars' 1 2!



!TextEditor methodsFor: '*EnclosableChars' stamp: 'JEC 2/22/2025 23:17:16'!
enclosableChar: aKeyboardEvent 
	"It's not the same as the one in:
		encloseWith:
	This feature behaves more like in IntelliJ or VSCode"

	| left oldSelection right startIndex stopIndex which |
	startIndex := self startIndex.
	stopIndex := self stopIndex.
	oldSelection := self selection.
	which := '([<{"''`' indexOf: aKeyboardEvent keyCharacter ifAbsent: [ ^true ].
	left := '([<{"''`' at: which.
	right := ')]>}"''`' at: which.

	self replaceSelectionWith: 
		(Text string: (UnicodeString with: left) attributes: emphasisHere),
		oldSelection,
		(Text string: (UnicodeString with: right) attributes: emphasisHere).
	
	self selectFrom: startIndex+1 to: stopIndex.

	^ true.! !

!TextEditor class methodsFor: '*EnclosableChars' stamp: 'JEC 2/19/2025 17:41:29'!
initializeKeyboardActions
	
	super initializeKeyboardActions.
	keyboardActions at: 9 + 1 put: #tabKey:.
	keyboardActions at: 11 + 1 put: #cursorPageUp:.			"page up key"
	keyboardActions at: 12 + 1 put: #cursorPageDown:.		"page down key"
	keyboardActions at: 30 + 1 put: #cursorUp:.				"up arrow key"
	keyboardActions at: 31 + 1 put: #cursorDown:.			"down arrow key"
	
	keyboardActions at: 34 + 1 put: #enclosableChar:.  "double quotes"
	keyboardActions at: 39 + 1 put: #enclosableChar:.  "single quote ' "
	keyboardActions at: 40 + 1 put: #enclosableChar:.  "parenthesis ("
	keyboardActions at: 60 + 1 put: #enclosableChar:.  "angle bracket <"
	keyboardActions at: 91 + 1 put: #enclosableChar:.  "square bracket ["
	keyboardActions at: 96 + 1 put: #enclosableChar:.  "backtick `"
	keyboardActions at: 123 + 1 put: #enclosableChar:.  "curly bracket {"! !

Editor initialize!