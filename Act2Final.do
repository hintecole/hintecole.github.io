clear all 

cd "C:\Users\hinte\Desktop\Descargas\638-Modulo67\Modulo67"

import dbase using "rec44.dbf", clear // talla y peso (23 089 variables) 

import dbase using "rec43.dbf", clear // salud niños (23 089 variables)

import dbase using "REC0111.dbf", clear //caracteristicas del hogar y de la mujer (39 745)


save "Base1.dta", replace
save "Base2.dta", replace 

use "Base1.dta", clear 
merge 1:1 _n using "Base2.dta"

drop in 23090/39745

drop _merge

save "BaseInicial.dta", replace 

import dbase using "rec21.dbf", clear 

keep CASEID B4

save "b4.dta", replace 

use "BaseInicial.dta", clear 
merge 1:1 _n using "b4.dta"

drop in 23090/70689

save "BaseInicial.dta", replace

*Recodificando las variables

recode V101 (1 = 1 "Amazonas") (2 = 2 "Ancash") (3 = 3 "Apurímac") (4 = 4 "Arequipa") (5 = 5 "Ayacucho") (6 = 6 "Cajamarca") (7 = 7 "Callao") (8 = 8 "Cusco") (9 = 9 "Huancavelica") (10 = 10 "Huánuco") (11 = 11 "Ica") (12 = 12 "Junín") (13 = 13 "La Libertad") (14 = 14 "Lambayeque") (15 = 15 "Lima") (16 = 16 "Loreto") (17 = 17 "Madre de Dios") (18 = 18 "Moquegua") (19 = 19 "Pasco") (20 = 20 "Piura") (21 = 21 "Puno") (22 = 22 "San Martín") (23 = 23 "Tacna") (24 = 24 "Tumbes") (25 = 25 "Ucayali"), gen(dpto)

label var dpto "Departamento"

keep if dpto==21

save "BasePuno.dta", replace 

use "BasePuno.dta", clear

*Variable sexo del jefe del hogar

recode V151 (1=1 "Hombre") (2=2 "Mujer"), gen(SJefe)

tab SJefe

label var SJefe "Sexo del Jefe del Hogar"

graph pie, over(SJefe) /// Sexo del Jefe del Hogar
plabel(_all percent, format(%12.2f) size(vmedium)) graphregion(color(white)) title("Porcentaje del Sexo del Jefe del Hogar") subtitle("Puno 2019") note(Fuente: INEI. Elaboración Propia) 

graph export "SexodelJefe.png", as(png) replace 

* Numero de niños menores de 5 años

tab V137 
rename V137 Niños5

label var Niños5 "Numero de niños menores de 5 años"

graph hbar, over(Niños5, sort(1) descending) ///
blabel(total, format(%12.1f)) graphregion(color(white)) title("Porcentaje del número de niños menores de 5 años") subtitle("Puno 2019") ytitle("Porcentaje") note(Fuente: INEI. Elaboración Propia) ///
ylabel(, nogrid) 

graph export "NiñosMenores5.png", as(png) replace 


*Variable etnicidad

recode V131 (1=1 "Quechua") (2=2 "Aymara") (10=10 "Castellano") (11=11 "Portugues"), gen(etni) 

label var etni "Etnicidad"

tab etni /// etnicidad 

graph pie, over(etni) ///
plabel(_all percent, format(%12.1f) size(vmedium)) graphregion(color(white)) title("Etnicidad de la Madre") subtitle("Puno 2019") note(Fuente: INEI. Elaboración Propia) 

graph export "EtnicidadMadre.png", as(png) replace 

*Variable parentesco con el jefe del hogar

recode V150 (1=1 "Jefe") (2=2 "Esposa") (3=3 "Hija") (4=4 "Nuera") (5=5 "Nieta") (8=8 "Hermana") (10=10 "Otro pariente") (11=11 "Niño Adoptado") (12=12 "No pariente"), gen(parenjef)

label var parenjef "Parentesco con el Jefe del Hogar"

*indice de riqueza 
recode V190 (1=1 "Muy pobre") (2=2 "Pobre") (3=3 "Medio") (4=4 "Rico") (5=5 "Muy rico"), gen(riqueza)
 
label var riqueza "Índice de Riqueza"
tab1 riqueza

*lugar de residencia
recode V025 (1=1 "Urbana") (2=2 "Rural"), gen(residencia)

label var residencia "Lugar de Residencia"
tab1 residencia

/**Nivel de educación alcanzado = V149 ("0"Sin educacion "1" Primaria Incompleta "2" Primaria Completa "3" Secundaria Incompleta "4" Secundaria Completa "5" Superior )

Educacion en Años simples = V133
Máx nivel de educacion = V106 ("0" Sin educacion "1" Primaria "2" Secundaria "3" Superior "9" Missing)

Máx años de educacion = V107
*Edad Actual de la entervistada = V012 
*Region = V024  ** PUNO = 21 */ 


*EDAD

rename V012 Edad
sort Edad
*TABLA EDAD CATEGÓRICA
recode Edad (12/17=0 "Adolescente (12-17 años) ") (18/29=1 "Jóvenes (18-29 años)") ///
(30/49=2 "Adultas (30-49 años)") (.=3 "Missing (No completó Información)"), gen(EdadCategorica)

label var EdadCategorica "Edad en Categoria"


*HISTOGRAMA EDAD DE MADRES

histogram Edad, width(5) start(12) graphregion(color(white)) percent fcolor(purple) ///
ytitle("Porcentaje") xtitle("Años de edad") title("Edad a nivel Individual de las madres") note("Fuente: Elaboracion propia en base a la ENDES" "El rango de edad se distribuye según la categoria brindada por el MINSA" "Siendo Adolescente (12-17 años), Jóvenes (18-29 años), Adultas 30-49 años)")

graph export "EdadMadres.png", as(png) replace

** EDUCACIÓN

br Edad V106 V107 V133 V149
sort Edad V106 V107 V133 V149

recode V149 (0=0 "Sin educación") (1=1 "Primaria Incompleta") (2=2 "Primaria Completa") (3=3 "Secundaria Incompleta") (4=4 "Secundaria Completa") (5=5 "Superior") (.=0), gen(Educación)
sort Educación
label var Educación "Educación"

tab Educación

rename V133 Años_Educativo
label var Años_Educativo "Años Educativos"

histogram Años_Educativo, width(2) graphregion(color(white)) percent fcolor(purple) ///
ytitle("Porcentaje") xtitle("Años de Educación") title("Años de Educación de la madre") note("Fuente: Elaboración propia en base a la ENDES" "Siendo Inicial - Primaria (0-5), Secundaria (6-10), Superior (10-15), PostGrado (16 a más)")

replace Años_Educativo=0 if Años_Educativo ==. 
tab Años_Educativo


*acá falta el histograma años de educación

*tabla de fuente de agua potable
recode V113 ///
		(11 = 1 "Red dentro de vivienda") ///
		(12 = 2 "Red fuera de la vivienda pero dentro de la edificacion") /// 
		(13 = 3 "Pilon o grifo publico") /// 
		(21 = 4 "Pozo dentro de la vivienda") /// 
		(22 = 5 "Pozo publico") ///
		(41 = 6 "Manantial") ///
		(43 = 7 "Rio, presa, lago, estanque, arroyo, canal o canal de irrigación") ///
		(61 = 8 "camion cisterna") /// 
		(71 = 9 "Agua embotellada") ///
		(96/99 = 10 "Otro"), gen(fuente_agua) 
label var fuente_agua "Fuente de agua"
tab fuente_agua

*tabla del sexo del niño/agua

recode B4 ///
		(1 = 1 "Hombre") ///
		(2 = 0 "Mujer"), gen(sexo_hijx)
		
label var sexo_hijx "Sexo del hijo o la hija"
tab sexo_hijx

*Creación de variable z-score

replace HW5=. if HW5==9999
gen zscore=HW5/100
kdensity zscore

/*en desn=1 if HW5<-200
replace desn=0 if HW5>=-200 & HW5<601
label define desn 1 "con desnutrición crónica" 0 "sin desnutrición crónica"
label var desn Desnutrición

save "BaseRegresion.dta", replace */

*regresión 

*Primero realizamos la regresión con todas las variables 

*Modelo 1

reg zscore ib1.fuente_agua ib1.sexo_hijx ib1.SJefe ib5.riqueza ib1.residencia Niños5 Edad Años_Educativo ib10.etni, level(95) cformat(%6.4fc) 
outreg2 using "Modelo.xls", bdec(4) sdec(4) stats(coef se) ctitle(Modelo 1) noparen addnote("Sea ***, **, * los niveles de significancia al 1%, 5% y 10%") excel replace

*Modelo 2

reg zscore Años_Educativo ib10.etni ib1.sexo_hijx, level(95) cformat(%6.4fc)
outreg2 using "Modelo.xls", bdec(4) sdec(4) stats(coef se) ctitle(Modelo 2) noparen addnote("Sea ***, **, * los niveles de significancia al 1%, 5% y 10%") excel

*Modelo 3 

reg zscore Años_Educativo ib10.etni ib1.sexo_hijx ib1.fuente_agua, level(95) cformat(%6.4fc)
outreg2 using "Modelo.xls", bdec(4) sdec(4) stats(coef se) ctitle(Modelo 3) noparen addnote("Sea ***, **, * los niveles de significancia al 1%, 5% y 10%") excel

*Modelo 4

reg zscore ib2.residencia ib1.fuente_agua ib1.sexo_hijx, level(95) cformat(%6.4fc)
outreg2 using "Modelo.xls", bdec(4) sdec(4) stats(coef se) ctitle(Modelo 4) noparen addnote("Sea ***, **, * los niveles de significancia al 1%, 5% y 10%") excel



















 