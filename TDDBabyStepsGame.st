!classDefinition: #TDDBabyStepsGameTest category: 'TDDBabyStepsGame'!
TestCase subclass: #TDDBabyStepsGameTest
	instanceVariableNames: 'game'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TDDBabyStepsGame'!

!TDDBabyStepsGameTest methodsFor: 'tests building' stamp: 'JMB 11/14/2021 22:04:08'!
test01WhenTheGameStartsTheTestCaseClassIsCreated
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #().
		
	self assert: (Smalltalk includesKey: game testCaseName).! !

!TDDBabyStepsGameTest methodsFor: 'tests building' stamp: 'JMB 11/14/2021 22:04:03'!
test02InTheFirstStepTheFirstTestIsAdded
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: true').
	
	game next.
	
	self assert: #(test01) asSet equals: game testCaseClass selectors asSet.! !

!TDDBabyStepsGameTest methodsFor: 'tests building' stamp: 'JMB 11/14/2021 22:03:57'!
test03InTheCurrentStepTheStepTestIsAdded
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: true' 'test02 self assert: true').
	game next.
	
	game next.
	
	self assert: #(test01 test02) asSet equals: game testCaseClass selectors asSet.! !

!TDDBabyStepsGameTest methodsFor: 'tests building' stamp: 'JMB 11/14/2021 22:03:52'!
test04WhenTheStepsAreCompletedYouCannotAdvanceToTheNextStep
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #().
	
	self 
		should: [ game next ] 
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ : anExpectedError |  
			self assert: TDDBabyStepsGame endOfGameErrorMessage equals: anExpectedError messageText.
			self deny: game testCaseClass hasMethods.
		].! !

!TDDBabyStepsGameTest methodsFor: 'tests building' stamp: 'JMB 11/16/2021 21:28:41'!
test05WhenTheGameStartsTheTestCaseClassIsCreatedInTheCategory
	
	| category |
	category := self class category.
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: true' 'test02 self assert: true') inCategory: category withDefinition: ''.
		
	self assert: category equals: game testCaseClass category	.
	
	! !


!TDDBabyStepsGameTest methodsFor: 'tests steps' stamp: 'JMB 11/16/2021 21:28:41'!
test06WhenATestDoesNotPassCannotGoToTheNextStep
	
	| category |
	category := self class category.
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: false' 'test02 self assert: false') inCategory: category withDefinition: ''.
	game next.
	
	self 
		should: [ game next ] 
		raise: Error 
		withExceptionDo: [ :anError | 
			self assert: TDDBabyStepsGame testsDoNotPassErrorMessage equals: anError messageText.
		]
	
	! !


!TDDBabyStepsGameTest methodsFor: 'tests scoring' stamp: 'JMB 11/17/2021 00:36:13'!
test07WhenTheGameStartsTheScoreIsZero
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #().
		
	self assert: 0 equals: game score.! !

!TDDBabyStepsGameTest methodsFor: 'tests scoring' stamp: 'JMB 11/17/2021 00:48:34'!
test08WhenThePlayerHasPassedTheTesTheScoreIsIncreased
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: false' 'test02 self assert: false').
	game next.
	self doPassTest: #test01.
	
	game next.
	
	self assert: 5 equals: game score.! !

!TDDBabyStepsGameTest methodsFor: 'tests scoring' stamp: 'JMB 11/17/2021 00:48:47'!
test09WhenThePlayerMadePrematureDecisionsTheScoreIsDecreased
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: false' 'test02 self assert: true').
	game next.
	self doPassTest: #test01.
	
	game next.
	
	self assert: -5 equals: game score.! !

!TDDBabyStepsGameTest methodsFor: 'tests scoring' stamp: 'JMB 11/17/2021 00:45:56'!
test10WhenThePlayerMadePrematureDecisionsInTheNextStepTheScoreIsNotIncreased
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: false' 'test02 self assert: true' 'test03 self assert: false').
	game next.
	self doPassTest: #test01.
	self doPassTest: #test02.
	game next.
	
	game next.
	
	self assert: -5 equals: game score.! !


!TDDBabyStepsGameTest methodsFor: 'tests journey' stamp: 'JMB 11/17/2021 00:56:37'!
test11WhenTheGameStartsTheJourneyIsEmpty
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #().
		
	self assert: game journey isEmpty.
	self assert: 'No ha realizado ningún paso' equals: (game lastStepTakenIfNone: [ 'No ha realizado ningún paso' ]).! !

!TDDBabyStepsGameTest methodsFor: 'tests journey' stamp: 'JMB 11/17/2021 00:56:43'!
test12WhenThePlayerHasPassedTheTestTheJourneyInformsTheAchievement
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: false' 'test02 self assert: false').
	game next.
	self doPassTest: #test01.
	
	game next.
	
	self assert: 'Has completado el tests, suma 5 puntos. Tu score es de 5' equals: (game lastStepTakenIfNone: [ '' ]).! !

!TDDBabyStepsGameTest methodsFor: 'tests journey' stamp: 'JMB 11/17/2021 00:57:07'!
test13WhenThePlayerMadePrematureDecisionsTheJourneyInformsTheWrongStep
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: false' 'test02 self assert: true').
	game next.
	self doPassTest: #test01.
	
	game next.
	
	self assert: 'Has tomado decisiones prematuras, resta 10 puntos. Tu score es de -5' equals: (game lastStepTakenIfNone: [ '' ]).! !

!TDDBabyStepsGameTest methodsFor: 'tests journey' stamp: 'JMB 11/17/2021 00:57:20'!
test14WhenThePlayerMadePrematureDecisionsInTheNextStepTheJourneyInformsTheProgressToTheNextStep
	
	game := TDDBabyStepsGame startNamed: 'myexample' withCases: #('test01 self assert: false' 'test02 self assert: true' 'test03 self assert: false').
	game next.
	self doPassTest: #test01.
	self doPassTest: #test02.
	game next.
	
	game next.
	
	self assert: 'Avanza al siguiente test. Tu score es de -5' equals: (game lastStepTakenIfNone: [ '' ]).! !


!TDDBabyStepsGameTest methodsFor: 'passing tests' stamp: 'JMB 10/29/2021 21:12:15'!
doPassTest: aTestSelector
	game testCaseClass compile: ('{1} self assert: true' format: {aTestSelector}) classified: 'tests'! !


!TDDBabyStepsGameTest methodsFor: 'setUp/tearDown' stamp: 'JMB 10/29/2021 20:51:22'!
removeGeneratedClass
	| generatedClass |
	game ifNil: [ ^ self ]. 
	generatedClass := Smalltalk at: game testCaseName ifAbsent: [ ^ self ].
	generatedClass removeFromSystem! !

!TDDBabyStepsGameTest methodsFor: 'setUp/tearDown' stamp: 'JMB 10/29/2021 20:47:06'!
tearDown
	super tearDown.
	self removeGeneratedClass. ! !


!classDefinition: #TDDBabyStepsGame category: 'TDDBabyStepsGame'!
Object subclass: #TDDBabyStepsGame
	instanceVariableNames: 'name casesToTest currentStep category score currentTest journey definition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TDDBabyStepsGame'!

!TDDBabyStepsGame methodsFor: 'private' stamp: 'JMB 11/9/2021 14:50:01'!
analyzePrematureDecisions
	self madePrematureDecisions ifTrue: [ 
		self decreaseScore.
	].! !

!TDDBabyStepsGame methodsFor: 'private' stamp: 'JMB 10/28/2021 19:55:11'!
assertTheCasesAreNotCompleted

	^ currentStep > casesToTest size 
		ifTrue: [ self error: self class endOfGameErrorMessage ]! !

!TDDBabyStepsGame methodsFor: 'private' stamp: 'JMB 11/17/2021 00:55:47'!
decreaseScore
	score := score - 10.
	journey add: ('Has tomado decisiones prematuras, resta 10 puntos. Tu score es de {1}' format: { self score })! !

!TDDBabyStepsGame methodsFor: 'private' stamp: 'JMB 11/14/2021 22:24:00'!
hasInPreviousStepPrematureDecisions
	| lastStepTaken |
	lastStepTaken := self lastStepTakenIfNone: [ ^ false ].
	^ lastStepTaken = ('Has tomado decisiones prematuras, resta 10 puntos. Tu score es de {1}' format: { self score }) ! !

!TDDBabyStepsGame methodsFor: 'private' stamp: 'JMB 10/28/2021 18:08:45'!
increaseCurrentStep
	currentStep := currentStep  + 1
! !

!TDDBabyStepsGame methodsFor: 'private' stamp: 'JMB 11/17/2021 00:55:47'!
increaseScore
	(currentStep > 0 and: [ self hasInPreviousStepPrematureDecisions not ]) ifTrue: [ 
		score := score + 5.
		journey add: ('Has completado el tests, suma 5 puntos. Tu score es de {1}' format: { self score })
	 ].
	self hasInPreviousStepPrematureDecisions ifTrue: [
		journey add: ('Avanza al siguiente test. Tu score es de {1}' format: { self score })
	].! !

!TDDBabyStepsGame methodsFor: 'private' stamp: 'JMB 10/29/2021 21:52:41'!
madePrematureDecisions
	^ currentTest isNil not and: [ self hasPassedCurrentTest ]! !

!TDDBabyStepsGame methodsFor: 'private' stamp: 'JMB 11/9/2021 14:50:30'!
stepCompleted
	self increaseScore.
	self increaseCurrentStep.
	self assertTheCasesAreNotCompleted.
	self addTestToTheTestCaseClass.
	self analyzePrematureDecisions.
! !


!TDDBabyStepsGame methodsFor: 'private - tests' stamp: 'JMB 10/29/2021 16:56:36'!
browseTestCase
	BrowserWindow fullOnClass: self testCaseClass "selector: primerTest"! !

!TDDBabyStepsGame methodsFor: 'private - tests' stamp: 'JMB 10/29/2021 21:42:25'!
hasPassedCurrentTest
	^ self runCurrentTest hasPassed! !

!TDDBabyStepsGame methodsFor: 'private - tests' stamp: 'JMB 10/29/2021 21:41:37'!
runCurrentTest
	| suite |
	suite _ TestSuite forCompiledMethod: self testCaseClass >> currentTest.
	^ suite run! !

!TDDBabyStepsGame methodsFor: 'private - tests' stamp: 'JMB 10/29/2021 17:05:06'!
runSuiteIfPassDo: aPassBlock ifDoesNotPass: aDoesNotPassBlock
		
	| testResult |
	testResult _ self testSuite run.	
	testResult hasPassed 
		ifTrue: aPassBlock
		ifFalse: aDoesNotPassBlock
	! !

!TDDBabyStepsGame methodsFor: 'private - tests' stamp: 'JMB 10/29/2021 16:51:51'!
testSuite
	^ TestSuite forClass: self testCaseClass! !


!TDDBabyStepsGame methodsFor: 'private - test case building' stamp: 'JMB 10/29/2021 21:35:27'!
addTestToTheTestCaseClass
	currentTest := self testCaseClass compile: self currentTest classified: 'tests'! !

!TDDBabyStepsGame methodsFor: 'private - test case building' stamp: 'JMB 10/28/2021 20:00:37'!
createTestCaseClass
	Compiler evaluate: self createTestCaseDefinition! !

!TDDBabyStepsGame methodsFor: 'private - test case building' stamp: 'JMB 10/28/2021 19:51:49'!
createTestCaseDefinition
	^ 'TestCase subclass: #{1}
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''{2}''' format: {self testCaseName. self testCaseCategory }! !

!TDDBabyStepsGame methodsFor: 'private - test case building' stamp: 'JMB 10/28/2021 19:56:16'!
currentTest

	^ casesToTest at: currentStep! !


!TDDBabyStepsGame methodsFor: 'test cases' stamp: 'JMB 10/28/2021 19:23:32'!
testCaseCategory
	^ category! !

!TDDBabyStepsGame methodsFor: 'test cases' stamp: 'JMB 8/15/2021 17:48:33'!
testCaseClass
	^ Smalltalk at: self testCaseName ! !

!TDDBabyStepsGame methodsFor: 'test cases' stamp: 'JMB 10/28/2021 18:45:49'!
testCaseName
	^ ('TDDBabySteps{1}Test' format: {name capitalized}) asSymbol! !


!TDDBabyStepsGame methodsFor: 'steps' stamp: 'JMB 11/17/2021 00:55:47'!
journey
	^ journey! !

!TDDBabyStepsGame methodsFor: 'steps' stamp: 'JMB 11/17/2021 00:55:47'!
lastStepTakenIfNone: exceptionBlock
	^ journey lastIfEmpty: exceptionBlock ! !

!TDDBabyStepsGame methodsFor: 'steps' stamp: 'JMB 11/14/2021 20:46:51'!
next
	self assertTheCasesAreNotCompleted.
	self 
		runSuiteIfPassDo: [ self stepCompleted ]
		ifDoesNotPass: [ self error: self class testsDoNotPassErrorMessage ].
	
! !

!TDDBabyStepsGame methodsFor: 'steps' stamp: 'JMB 10/29/2021 21:21:38'!
score
	^ score! !


!TDDBabyStepsGame methodsFor: 'statements' stamp: 'JMB 11/16/2021 21:27:44'!
definition
	^ definition! !

!TDDBabyStepsGame methodsFor: 'statements' stamp: 'JMB 11/16/2021 23:57:32'!
help
	^ '
1- Iniciar un juego. Usted comienza con un score de 0. Al comenzar se creara la clase de test y se abrirá un class browser.  
2- De el primer paso donde se incluirá el siguiente caso de test: 

	game next. 

3- Correr el test generado en el paso anterior, si pasa de una resta 10 puntos de su score y vaya al paso 5.

4- Hacer pasar el test con la implementación mínima. 
	- Si no puede hacerlo pasar GAME OVER con score -100 y vaya al paso 6. 
	- Si lo hizo pasar, suma 5 puntos a su score.

5- Avance al siguiente caso de test y vaya al paso 3. Si completo todos los casos, vaya al paso 6

game next

6- Ha finalizado el juego y si:
	- su score es 30 puntos:  ¡felicitaciones ha aplicado muy bien los pasos mínimos!!. 
	- su score esta entre 20 y 30 ¡bien solo ha cometido 1 error!! Vuelva a intentarlo analizando en qué paso no ha hecho la implementación mínima. 
	- su score es entre 0 y 20. Necesita repasar la técnica, no ha realizado los pasos mínimos. Vuelva a intentarlo analizando en qué paso no ha hecho la implementación mínima. 
	- su score es entre -30 y 0. Necesita repasar fuertemente la técnica, no ha realizado los pasos mínimos. Vuelva a intentarlo analizando en qué paso no ha hecho la implementación mínima. 
	- Si su score es menor a -30, lamentablemente ha perdido el juego. Necesita repasar los conceptos de la materia.

'! !

!TDDBabyStepsGame methodsFor: 'statements' stamp: 'JMB 11/16/2021 21:32:52'!
name
	^ name! !


!TDDBabyStepsGame methodsFor: 'initialization' stamp: 'JMB 11/17/2021 00:55:47'!
initializeNamed: aName withCases: aCasesToTest inCategory: aCategory withDefinition: aDefinition 
	name := aName.
	casesToTest := aCasesToTest.
	category := aCategory.
	definition := aDefinition. 
	currentStep := 0.
	score := 0.
	journey := OrderedCollection new.
	self createTestCaseClass.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TDDBabyStepsGame class' category: 'TDDBabyStepsGame'!
TDDBabyStepsGame class
	instanceVariableNames: ''!

!TDDBabyStepsGame class methodsFor: 'instance creation' stamp: 'JMB 11/16/2021 21:28:41'!
startNamed: aName withCases: casesToTest 
	^self startNamed: aName withCases: casesToTest inCategory: self category withDefinition: ''! !

!TDDBabyStepsGame class methodsFor: 'instance creation' stamp: 'JMB 11/16/2021 21:29:37'!
startNamed: aName withCases: casesToTest  inCategory: aCategory withDefinition: aDefinition  
	^self new initializeNamed: aName withCases: casesToTest inCategory: aCategory withDefinition: aDefinition ! !


!TDDBabyStepsGame class methodsFor: 'messages' stamp: 'JMB 10/28/2021 18:17:47'!
endOfGameErrorMessage
	^ '¡Felicitaciones!! Has finalizado el juego'! !

!TDDBabyStepsGame class methodsFor: 'messages' stamp: 'JMB 11/14/2021 20:38:46'!
testsDoNotPassErrorMessage
	^ 'No se puede avanzar si no pasan todos los tests'! !


!classDefinition: #TDDBabyStepsGameCalendar category: 'TDDBabyStepsGame'!
Object subclass: #TDDBabyStepsGameCalendar
	instanceVariableNames: 'game'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TDDBabyStepsGame'!
!TDDBabyStepsGameCalendar commentStamp: 'JMB 10/29/2021 22:06:48' prior: 0!
| game |
game  := TDDBabyStepsGameCalendar start.
game openHelp.
game openDefinition.
game next.!


!TDDBabyStepsGameCalendar methodsFor: 'building' stamp: 'JMB 11/16/2021 22:56:39'!
build
	^ TDDBabyStepsGameView for: self buildGame.! !

!TDDBabyStepsGameCalendar methodsFor: 'building' stamp: 'JMB 11/16/2021 22:56:53'!
start
	game := self build.
	self createTestCaseContext. 
	^ game start! !


!TDDBabyStepsGameCalendar methodsFor: 'private' stamp: 'JMB 11/16/2021 22:56:14'!
buildGame
	^ TDDBabyStepsGame startNamed: self name withCases: self cases inCategory: 'TDDBabyStepsGame', self name capitalized withDefinition: self definition.! !

!TDDBabyStepsGameCalendar methodsFor: 'private' stamp: 'JMB 11/16/2021 22:57:29'!
createTestCaseContext! !

!TDDBabyStepsGameCalendar methodsFor: 'private' stamp: 'JMB 10/28/2021 20:26:38'!
definition
	^ '
Enunciado

Nuestro cliente ha venido con una nueva idea, y nos ha contratado para llevar adelante el desarrollo de un software para gestionar eventos del calendario. El objetivo es poder crear calendarios para luego poder saber si un lugar en está disponible o no.

Todos los eventos tienen una hora de inicio y fin en cierto día. Ejemplo: De 10:00 a 11:00 el 1/8/2021

Los calendarios deben servir para saber si un lugar en ellos está disponible. Por ejemplo, si el calendario de Ana Rodriguez tiene un evento de 10 a 11 hrs el día 1/8/2021 y se le pregunta si hay lugar disponible entre las 9:30 y 10:30 del 1/8/2021, debería decir que no. Mientras que si se le pregunta si hay lugar entre las 11:00 y 12:00 ese mismo día debería decir que sí.


Ayudas:
	- August/1/2021 crea la fecha 1 de Agosto de 2021
	- 10:00 crea la hora 10:00
	- August/1/2021 at: 10:00 crea el día/hora del 1 de Agosto de 2021 a las 10:00

'! !

!TDDBabyStepsGameCalendar methodsFor: 'private' stamp: 'JMB 10/28/2021 20:14:14'!
name 
	^ 'Calendar'! !


!TDDBabyStepsGameCalendar methodsFor: 'private - cases' stamp: 'JMB 10/29/2021 22:01:33'!
case01
	^ 'test01CalendarWithoutEventsIsFreeAtAnyMoment
	
	| calendar |
	calendar := Calendar new.
	
	self assert: (calendar isFreeAt: October/20/2021 from: 10:00 to: 11:00)
	'! !

!TDDBabyStepsGameCalendar methodsFor: 'private - cases' stamp: 'JMB 10/29/2021 22:01:43'!
case02
	^ 'test02CalendarIsNotFreeForSameDateAndTimeAsAnOneTimeEvent
	
	| calendar |
	calendar := Calendar new.
	calendar addOneTimeEventAt: October/30/2021 from: 13:00 to: 15:00.
	
	self deny: (calendar isFreeAt: October/30/2021 from: 13:00 to: 15:00)
	' ! !

!TDDBabyStepsGameCalendar methodsFor: 'private - cases' stamp: 'JMB 10/29/2021 21:59:52'!
case03
	^ 'test03CalendarIsFreeWhenEndTimeIsBeforeOrEqualToTheOneTimeEventStartTime
	
	| calendar |
	calendar := Calendar new.
	calendar addOneTimeEventAt: October/30/2021 from: 10:00 to: 11:00.
	
	self assert: (calendar isFreeAt: October/30/2021 from: 09:00 to: 10:00)
	'! !

!TDDBabyStepsGameCalendar methodsFor: 'private - cases' stamp: 'JMB 10/29/2021 22:02:14'!
case04
	^ 'test04CalendarIsFreeWhenStartTimeIsAfterOrEqualToTheOneTimeEventEndTime
	
	| calendar |
	calendar := Calendar new.
	calendar addOneTimeEventAt: October/30/2021 from: 10:00 to: 11:00.
	
	self assert: (calendar isFreeAt: October/30/2021 from: 11:00 to: 12:00)
	'! !

!TDDBabyStepsGameCalendar methodsFor: 'private - cases' stamp: 'JMB 10/29/2021 22:02:39'!
case05
	^ 'test05CalendarIsFreeWhenDateIsDifferentToTheOneTimeEventDate
	
	| calendar |
	calendar := Calendar new.
	calendar addOneTimeEventAt: October/30/2021 from: 10:00 to: 11:00.
	
	self assert: (calendar isFreeAt: November/1/2021 from: 10:00 to: 11:00)
	'! !

!TDDBabyStepsGameCalendar methodsFor: 'private - cases' stamp: 'JMB 10/29/2021 22:03:09'!
case06
	^ 'test06CalendarIsNotFreeWhenTheDateAndTimeIsDifferentsToAllTheEvents
	
	| calendar |
	calendar := Calendar new.
	calendar addOneTimeEventAt: October/30/2021 from: 10:00 to: 11:00.
	calendar addOneTimeEventAt: November/1/2021 from: 10:00 to: 11:00.
	
	self deny: (calendar isFreeAt: October/30/2021 from: 10:00 to: 11:00).
	self deny: (calendar isFreeAt: November/1/2021 from: 10:00 to: 11:00)
	'! !

!TDDBabyStepsGameCalendar methodsFor: 'private - cases' stamp: 'JMB 10/28/2021 18:49:17'!
cases
	^ {self case01. self case02. self case03. self case04. self case05. self case06 }! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TDDBabyStepsGameCalendar class' category: 'TDDBabyStepsGame'!
TDDBabyStepsGameCalendar class
	instanceVariableNames: ''!

!TDDBabyStepsGameCalendar class methodsFor: 'instance creation' stamp: 'JMB 10/29/2021 22:05:47'!
start
	^ self new start! !


!classDefinition: #TDDBabyStepsGameContador category: 'TDDBabyStepsGame'!
Object subclass: #TDDBabyStepsGameContador
	instanceVariableNames: 'game'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TDDBabyStepsGame'!
!TDDBabyStepsGameContador commentStamp: '<historical>' prior: 0!
| game |
game  := TDDBabyStepsGameContador start.
game openHelp.
game openDefinition.
game next.!


!TDDBabyStepsGameContador methodsFor: 'building' stamp: 'JMB 11/16/2021 22:45:32'!
build
	^ TDDBabyStepsGameView for: self buildGame.! !

!TDDBabyStepsGameContador methodsFor: 'building' stamp: 'JMB 11/16/2021 22:54:32'!
start
	game := self build.
	self createTestCaseContext. 
	^ game start! !


!TDDBabyStepsGameContador methodsFor: 'private' stamp: 'JMB 11/16/2021 22:39:27'!
buildGame
	^ TDDBabyStepsGame startNamed: self name withCases: self cases inCategory: 'TDDBabyStepsGame', self name capitalized withDefinition: self definition.
! !

!TDDBabyStepsGameContador methodsFor: 'private' stamp: 'FL 11/9/2021 20:35:35'!
createContadorDefinition
	^ 'TestCase subclass: #{1}
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''{2}''' format: {self name. game testCaseCategory }! !

!TDDBabyStepsGameContador methodsFor: 'private' stamp: 'JMB 11/16/2021 22:54:32'!
createTestCaseContext
	Compiler evaluate: self createContadorDefinition! !

!TDDBabyStepsGameContador methodsFor: 'private' stamp: 'FL 11/9/2021 20:24:52'!
definition
	^ ' Implementar un contador que recibe el mensaje incrementar para incrementar en 1 su valor.
	El contador debe comenzar de 0.
	El contador tambien sabe responder el mensaje value para obtener su valor.
'! !

!TDDBabyStepsGameContador methodsFor: 'private' stamp: 'FL 11/9/2021 20:23:07'!
name 
	^ 'Contador'! !


!TDDBabyStepsGameContador methodsFor: 'private - cases' stamp: 'FL 11/9/2021 20:55:37'!
case01
	^ 'test01UnNuevoContadorEmpiezaConValorCero

	| contador |
	contador := Contador new.
	self assert: 0 equals: contador valor.
	'! !

!TDDBabyStepsGameContador methodsFor: 'private - cases' stamp: 'FL 11/9/2021 20:56:57'!
case02
	^ 'test02AlIncrementarUnaVezElContadorSuValorSubeUno

	| contador |
	contador := Contador new.
	contador incrementar.
	self assert: 1 equals: contador valor.
	' ! !

!TDDBabyStepsGameContador methodsFor: 'private - cases' stamp: 'FL 11/9/2021 20:59:28'!
case03
	^ 'test03SePuedeIncrementarVariasVecesElContadorYSuValorIncrementaEnUnoEsaCantidadDeVeces

	| contador |
	contador := Contador new.
	contador incrementar.
	contador incrementar.
	contador incrementar.
	self assert: 3 equals: contador valor.
	'! !

!TDDBabyStepsGameContador methodsFor: 'private - cases' stamp: 'FL 11/9/2021 20:22:50'!
cases
	^ {self case01. self case02. self case03. }! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TDDBabyStepsGameContador class' category: 'TDDBabyStepsGame'!
TDDBabyStepsGameContador class
	instanceVariableNames: ''!

!TDDBabyStepsGameContador class methodsFor: 'instance creation' stamp: 'FL 11/9/2021 20:19:59'!
start
	^ self new start! !


!classDefinition: #TDDBabyStepsGameCuentaBancaria category: 'TDDBabyStepsGame'!
Object subclass: #TDDBabyStepsGameCuentaBancaria
	instanceVariableNames: 'game'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TDDBabyStepsGame'!
!TDDBabyStepsGameCuentaBancaria commentStamp: '<historical>' prior: 0!
| game |
game  := TDDBabyStepsGameCuentaBancaria start.
game openHelp.
game openDefinition.
game next.!


!TDDBabyStepsGameCuentaBancaria methodsFor: 'building' stamp: 'JMB 11/16/2021 23:51:11'!
build
	^ TDDBabyStepsGameView for: self buildGame.! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'building' stamp: 'JMB 11/16/2021 23:50:54'!
start
	game := self build.
	self createTestCaseContext. 
	^ game start! !


!TDDBabyStepsGameCuentaBancaria methodsFor: 'private' stamp: 'JMB 11/16/2021 23:49:48'!
buildGame
	^ TDDBabyStepsGame startNamed: self name withCases: self cases inCategory: 'TDDBabyStepsGame', self name capitalized withDefinition: self definition.
	! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'private' stamp: 'FL 11/12/2021 16:16:08'!
createCuentaBancariaDefinition

	^ 'TestCase subclass: #{1}
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''{2}''' format: {self name. game testCaseCategory }! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'private' stamp: 'JMB 11/16/2021 23:51:42'!
createTestCaseContext

	Compiler evaluate: self createCuentaBancariaDefinition! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'private' stamp: 'FL 11/15/2021 18:31:13'!
definition
	^ 'Uno de nuestros clientes nos pide crear un modelo de una cuenta bancaria, de modo que nos permita las siguientes operaciones:
		- Realizar uno o mas depositos en pesos.
		- Realizar una o mas extracciones en pesos.
		- Otro punto importante, es que si la cuenta tiene un saldo menor al monto que se desea extraer,
		  debe levantarse un error indicando: "La cuenta no puede quedar en descubierto"
	'! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'private' stamp: 'FL 11/12/2021 16:13:07'!
name 
	^ 'CuentaBancariaEnPesos'! !


!TDDBabyStepsGameCuentaBancaria methodsFor: 'private - cases' stamp: 'FL 11/12/2021 16:09:58'!
case01
	^ 'test01UnaNuevaCuentaComienzaConSaldoCero
	
	self assert: 0 * peso equals: CuentaBancariaEnPesos new saldo.
	'! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'private - cases' stamp: 'FL 11/12/2021 16:10:18'!
case02
	^ 'test02AlHacerUnDepositoSeIncrementaElSaldoConElMontoDepositado
	
	| cuentaBancaria |
	cuentaBancaria := CuentaBancariaEnPesos new.
	cuentaBancaria depositar: 10 * peso.
 	self assert: 10 * peso equals: cuentaBancaria saldo.
	' ! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'private - cases' stamp: 'FL 11/12/2021 16:10:30'!
case03
	^ 'test03AlHacerVariosDepositosSeIncrementaElSaldoConElTotalDepositado
	
	| cuentaBancaria |
	cuentaBancaria := CuentaBancariaEnPesos new.
	cuentaBancaria depositar: 10 * peso.
	cuentaBancaria depositar: 20 * peso.
 	self assert: 30 * peso equals: cuentaBancaria saldo.
	'! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'private - cases' stamp: 'FL 11/12/2021 16:10:55'!
case04
	^ 'test04AlExtrerDisminuyeElSaldoSegunElMontoExtraido
	
	| cuentaBancaria |
	cuentaBancaria := CuentaBancariaEnPesos new.
	cuentaBancaria depositar: 30 * peso.
	cuentaBancaria extraer: 20 * peso.
 	self assert: 10 * peso equals: cuentaBancaria saldo.
	'! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'private - cases' stamp: 'FL 11/12/2021 16:11:57'!
case05
	^ 'test05AlExtraerLaCuentaNoPuedeQuedarEnDescubierto
	
	| cuentaBancaria |
	cuentaBancaria := CuentaBancariaEnPesos new.
	cuentaBancaria depositar: 30 * peso.
	cuentaBancaria extraer: 20 * peso.
	self should: [cuentaBancaria extraer: 11 * peso.] 
		raise: Error  
		withExceptionDo: [:anException | 
			self assert: ''La cuenta no puede quedar en descubierto'' equals: anException messageText. 
			self assert: 10 * peso equals: cuentaBancaria saldo.
		].
	'! !

!TDDBabyStepsGameCuentaBancaria methodsFor: 'private - cases' stamp: 'FL 11/12/2021 16:12:20'!
cases
	^ {self case01. self case02. self case03. self case04. self case05. }! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TDDBabyStepsGameCuentaBancaria class' category: 'TDDBabyStepsGame'!
TDDBabyStepsGameCuentaBancaria class
	instanceVariableNames: ''!

!TDDBabyStepsGameCuentaBancaria class methodsFor: 'instance creation' stamp: 'FL 11/12/2021 15:31:08'!
start
	^ self new start! !


!classDefinition: #TDDBabyStepsGameDemo category: 'TDDBabyStepsGame'!
Object subclass: #TDDBabyStepsGameDemo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TDDBabyStepsGame'!
!TDDBabyStepsGameDemo commentStamp: '<historical>' prior: 0!
| game |
game  := TDDBabyStepsGameDemo start.
game openHelp.
game openDefinition.
game next.!


!TDDBabyStepsGameDemo methodsFor: 'building' stamp: 'JMB 11/16/2021 22:35:21'!
build
	^ TDDBabyStepsGameView for: self buildGame.

	! !

!TDDBabyStepsGameDemo methodsFor: 'building' stamp: 'JMB 11/16/2021 22:48:18'!
start
	^ self build! !


!TDDBabyStepsGameDemo methodsFor: 'private' stamp: 'JMB 11/16/2021 22:33:15'!
buildGame
	^ TDDBabyStepsGame startNamed: self name withCases: self cases inCategory: 'TDDBabyStepsGame', self name capitalized withDefinition: self definition.

	! !

!TDDBabyStepsGameDemo methodsFor: 'private' stamp: 'FL 11/12/2021 15:00:37'!
definition
	^ ' Definicion de demostracion.'! !

!TDDBabyStepsGameDemo methodsFor: 'private' stamp: 'FL 11/9/2021 21:09:18'!
name 
	^ 'Demo'! !


!TDDBabyStepsGameDemo methodsFor: 'private - cases' stamp: 'FL 11/9/2021 21:06:15'!
case01
	^ 'test01
	self assert: false.
	'! !

!TDDBabyStepsGameDemo methodsFor: 'private - cases' stamp: 'FL 11/9/2021 21:08:10'!
case02
	^ 'test02
	self assert: false.
	' ! !

!TDDBabyStepsGameDemo methodsFor: 'private - cases' stamp: 'FL 11/9/2021 21:08:30'!
case03
	^ 'test03
	self assert: false.
	'! !

!TDDBabyStepsGameDemo methodsFor: 'private - cases' stamp: 'FL 11/12/2021 14:59:28'!
case04
	^ 'test04
	self assert: true.
	'! !

!TDDBabyStepsGameDemo methodsFor: 'private - cases' stamp: 'FL 11/12/2021 15:00:57'!
cases
	^ {self case01. self case02. self case03. self case04. }! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TDDBabyStepsGameDemo class' category: 'TDDBabyStepsGame'!
TDDBabyStepsGameDemo class
	instanceVariableNames: ''!

!TDDBabyStepsGameDemo class methodsFor: 'instance creation' stamp: 'JMB 11/16/2021 22:48:31'!
start
	^ self new start! !


!classDefinition: #TDDBabyStepsGameView category: 'TDDBabyStepsGame'!
Object subclass: #TDDBabyStepsGameView
	instanceVariableNames: 'model'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TDDBabyStepsGame'!

!TDDBabyStepsGameView methodsFor: 'initialization' stamp: 'JMB 11/14/2021 20:14:42'!
initializeFor: aGame
	model := aGame ! !


!TDDBabyStepsGameView methodsFor: 'steps' stamp: 'JMB 11/16/2021 18:55:56'!
next
	[ model next ]
		on: Error - MessageNotUnderstood 
		do: [ : anError |
			anError messageText = model class testsDoNotPassErrorMessage
				ifTrue: [ self inform: 'No puede avanzar, no pasan todos sus tests' ].
			anError messageText = model class endOfGameErrorMessage 
				ifTrue: [ self inform: ('¡Felicitaciones!! Has finalizado el juego con un score de {1}' format: {model score }) ].
			^ self
		].
	self informStepResult.! !

!TDDBabyStepsGameView methodsFor: 'steps' stamp: 'JMB 11/16/2021 23:58:07'!
start
	model browseTestCase. 
	self informStart! !


!TDDBabyStepsGameView methodsFor: 'statements' stamp: 'JMB 11/16/2021 21:33:03'!
openDefinition
	TextModel new contents: model definition; openLabel: 'Enunciado ', model name.! !

!TDDBabyStepsGameView methodsFor: 'statements' stamp: 'JMB 11/16/2021 21:39:15'!
openHelp
	TextModel new contents: model help; openLabel: model name, ' Ayuda'.! !


!TDDBabyStepsGameView methodsFor: 'test cases' stamp: 'JMB 11/16/2021 22:51:51'!
testCaseCategory
	^ model testCaseCategory! !


!TDDBabyStepsGameView methodsFor: 'private' stamp: 'JMB 11/17/2021 00:18:24'!
informStart
	self inform: 'El juego inicia. Se ha creado la clase de test. Avance al siguiente paso para generar el primer test que debemos hacer pasar.'! !

!TDDBabyStepsGameView methodsFor: 'private' stamp: 'JMB 11/14/2021 21:32:15'!
informStepResult
	| lastStepTaken |
	lastStepTaken := model lastStepTakenIfNone: [ ^ self ].
	self inform: lastStepTaken! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TDDBabyStepsGameView class' category: 'TDDBabyStepsGame'!
TDDBabyStepsGameView class
	instanceVariableNames: ''!

!TDDBabyStepsGameView class methodsFor: 'instance creation' stamp: 'JMB 11/14/2021 20:12:56'!
for: aGame
	^ self new initializeFor: aGame! !
