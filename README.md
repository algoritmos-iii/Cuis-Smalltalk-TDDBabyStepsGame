# Cuis-Smalltalk-TDDBabyStepsGame



# Iniciar un juego

```Smalltalk
| game |
game := TDDBabyStepsGameDemo start. 
game openHelp. "Dinámica del juego"
game openDefinition. "Definicion del problema a modelar"
game next. "Avanzar al siguiente paso"

```
# Juegos

- TDDBabyStepsGameContador
- TDDBabyStepsGameCuentaBancaria
- TDDBabyStepsGameCalendar


# Dinámica del juego

1- Iniciar un juego. Usted comienza con un score de 0. Al comenzar se creara la clase de test y se abrirá un class browser.  
2- De el primer paso donde se incluirá el siguiente caso de test: 

	`game next.` 

3- Correr el test generado en el paso anterior, si pasa de una resta puntos de su score y vaya al paso 5.

4- Hacer pasar el test con la implementación mínima. 
	- Si no puede hacerlo pasar GAME OVER y vaya al paso 6. 
	- Si lo hizo pasar, suma puntos a su score.

5- Avance al siguiente caso de test y vaya al paso 3. Si completo todos los casos, vaya al paso 6

`game next.`  
