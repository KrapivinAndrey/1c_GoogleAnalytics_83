﻿&НаКлиенте
Перем СоединениеГА;
&НаКлиенте
Перем РежимТестирования;

#Область Временное_хранилище

&НаКлиенте
Процедура ПоместитьВоВХ(Имя,Значение) Экспорт
	
	ПоместитьВоВременноеХранилище(Значение, Объект.ПараметрыКлиентСерверGA.АдресаВХ[Имя]);
				
КонецПроцедуры

&НаКлиенте
Функция ИзвлечьИзВХ(Имя) Экспорт
	
	АдресВХ = Объект.ПараметрыКлиентСерверGA.АдресаВХ[Имя];
	
	Если Не ЭтоАдресВременногоХранилища(АдресВХ) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПолучитьИзВременногоХранилища(АдресВХ);
			
КонецФункции

#КонецОбласти

#Область ПреобразоватькURL

&НаКлиенте
Функция ПреобразоватьКURL(Стр)
	
	Длина = СтрДлина( Стр );
	Итог = "";
	
	Для Н = 1 По Длина Цикл
		
		Знак = Сред(       Стр, Н, 1 );
		Код  = КодСимвола( Знак );
		
		Если Знак = " " Тогда
			Итог = Итог + "%20";
		ИначеЕсли Знак = "/" Тогда
			Итог = Итог + "%2F";
		ИначеЕсли Знак = "\" Тогда
			Итог = Итог + "%5C";
		ИначеЕсли ( ( Знак >= "a" )и( Знак <= "z" ) ) Или
			(  ( Знак >= "A" )и( Знак <= "Z" ) ) Или
				( ( Знак >= "0" )и( Знак <= "9" ) ) Тогда
			
			Итог = Итог + Знак;
			
		Иначе
			
			Если ( Код >= КодСимвола( "А" ) )И( Код <= КодСимвола( "п" ) ) Тогда
				
				Итог = Итог + "%" + ПреобразоватьвСистему(       208,
														   16 ) + "%" + ПреобразоватьвСистему(
														   	144 + Код - КодСимвола(
															   	"А" ),
															   16 );
															   
			ИначеЕсли ( Код >= КодСимвола( "р" ) )И( Код <= КодСимвола( "я" ) ) Тогда
				
				Итог = Итог + "%" + ПреобразоватьвСистему(       209,
														   16 ) + "%" + ПреобразоватьвСистему(
														   	128 + Код - КодСимвола(
															   	"р" ),
															   16 );
															   
			ИначеЕсли ( Знак = "ё" ) Тогда
				
				Итог = Итог + "%" + ПреобразоватьвСистему( 209, 16 ) + "%" + ПреобразоватьвСистему( 145, 16 );
				
			ИначеЕсли ( Знак = "Ё" ) Тогда
				
				Итог = Итог + "%" + ПреобразоватьвСистему( 208, 16 ) + "%" + ПреобразоватьвСистему( 129, 16 );
				
			Иначе
				
				//Итог = Итог + "%" + ПреобразоватьвСистему( Код, 16 );
				Итог = Итог + Знак;
			КонецЕсли;
		
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Итог;
КонецФункции

&НаКлиенте
Функция ПреобразоватьвСистему(Число10,система)
	
	Если система > 36 или система < 2 тогда
		Сообщить("Выбранная система исчисления не поддерживается");
		Возврат -1;
	КонецЕсли;
	
	СтрокаЗначений = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	СтрокаСистема = "";
	Пока Число10 > 0 цикл
		РезДеления = Число10/система;
		ЧислоСистема = цел(РезДеления);
		остатокОтДеления = Число10 - система*(ЧислоСистема);
		СтрокаСистема = сред(СтрокаЗначений,остатокОтДеления+1,1)+ СтрокаСистема;
		Число10 = ?(ЧислоСистема=0,0,РезДеления); 
	КонецЦикла;
	
	//!!!!!!!!
	//[
	Нечётное = стрДлина(СтрокаСистема) - цел(стрДлина(СтрокаСистема)/2)*2;
	Если Нечётное тогда
		СтрокаСистема = "0"+СтрокаСистема;
	КонецЕсли;
	//]
	Возврат СтрокаСистема;
КонецФункции

#КонецОбласти

#Область Вспомогательные_Клиент

&НаКлиенте
Функция ПолучитьСтрокуПараметров(СтруктураПараметров)
	
	СтрокаПараметров = Объект.ПараметрыКлиентСерверGA.ОбязательныеПараметры;
	
	Для Каждого Эл Из СтруктураПараметров Цикл
		СтрокаПараметров = СтрокаПараметров + "&" + СокрЛП(Эл.Ключ) + "=" + ПреобразоватьПараметр(Эл.Значение);
	КонецЦикла;
	
	Возврат СтрокаПараметров;
	
КонецФункции

&НаКлиенте
Функция ПреобразоватьПараметр(Параметр)

	Возврат ПреобразоватьКURL(Параметр);

КонецФункции // ПреобразоватьПараметр()

&НаКлиенте
Функция АдресЗапроса()
	Результат = "";
	Если РежимТестирования() Тогда
		Результат = Объект.ПараметрыКлиентСерверGA.URLАдреса.Test + "/";
	КонецЕсли;
	Результат = Объект.ПараметрыКлиентСерверGA.URLАдреса.Work;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область Работа_с_Google_Analytics

&НаКлиенте
// Отправляет данные на сервер 
//
// Параметры:
//  ТипДанных  - Строка - Hit type, тип отправляемых данных
//                 событие, просмотр страницы и т.д.
//  ДопПараметры  - Структура - параметры фиксируемого события
//
// Возвращаемое значение:
//   Структура   - результат запроса: Успешно и описание ошибок
//
Функция Гугл_ОтправитьЗапрос(ТипДанных, ДопПараметры)
	
	СтрокаПараметров	= "t=" + ТипДанных + "&" + ПолучитьСтрокуПараметров(ДопПараметры);
	
	Возврат ОтправитьHTTPЗапрос(СтрокаПараметров);
	
КонецФункции // Гугл_ОтправитьЗапрос()

&НаКлиенте
// Отправить в GA данные о каком-либо пользовательском действии
//
// Параметры
//  Категория			- Строка 		- обобщение однотипных действий
//											например: СвязиКонтрагентов, ПроверкаКонтрагентов
//							
//  ОписаниеДействия	- Строка 		- отличительный признаки действия
//											например: НажатиеКнопки, ВводТекста
//	Подпись				- Строка		- имя элемента связанного с действием
//	ЦенностьСобытия		- Чило			- передаваемые данные
//	ПараметрыЗапроса	- Структура		- дополнительные данные
//
Функция ОтправитьСобытие(Категория, ОписаниеДействия, Подпись = "", 
									ЦенностьСобытия = Неопределено, ПараметрыЗапроса = Неопределено) Экспорт
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ec", Категория);
	ДопПараметры.Вставить("ea", ОписаниеДействия);
	ДопПараметры.Вставить("el", Подпись);
	ДопПараметры.Вставить("ev", ЦенностьСобытия);
	
	
	Если ПустаяСтрока(Подпись) Тогда
		ДопПараметры.Удалить("el");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ЦенностьСобытия) Тогда 
		ДопПараметры.Удалить("ev");
	КонецЕсли;
	
	//ДополнитьПараметры(ДопПараметры, ПараметрыЗапроса);	
	Возврат Гугл_ОтправитьЗапрос("event", ДопПараметры);
КонецФункции

&НаКлиенте
// Отправить в GA данные о просмотре формы или страницы
//
// Параметры:
//  ИмяЭкрана  - Строка - название формы или страницы
//
// Возвращаемое значение:
//   Форма   - <описание возвращаемого значения>
//
Функция ОтправитьПросмотрЭкрана(ИмяЭкрана) Экспорт

	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("cd", ИмяЭкрана);
	
	Возврат Гугл_ОтправитьЗапрос("screenview", ДопПараметры);

КонецФункции // ОтправитьПросмотрЭкрана()


#КонецОбласти

&НаКлиенте
Функция СоединениеГА()
	Если СоединениеГА = Неопределено Тогда
		СоединениеГА = ПолучитьОбъектСоединение();
	КонецЕсли;
	
	Возврат СоединениеГА;
КонецФункции

&НаКлиенте
Функция РежимТестирования()
	Если РежимТестирования = Неопределено Тогда
		РежимТестирования = ИзвлечьИзВХ("РежимТестирования");
		Если РежимТестирования = Неопределено Тогда
			РежимТестирования = Ложь;
			ПоместитьВоВХ("РежимТестирования", РежимТестирования);
		КонецЕсли;
	КонецЕсли;
	
	Возврат РежимТестирования;
КонецФункции

&НаКлиенте
Функция ПолучитьОбъектСоединение()
	
	// Метод присутствует в клиентском и серверном модулях
	
	Попытка		
		Результат = Новый HTTPСоединение(Объект.ПараметрыКлиентСерверGA.URLАдреса.GoogleAnalytics, , , , , ,Новый ЗащищенноеСоединениеOpenSSL);
	Исключение		
		_ОписаниеОшибки = ОписаниеОшибки();
		Возврат Неопределено;		
	КонецПопытки;
		
	Возврат Результат;
	
КонецФункции

&НаКлиенте
// Отправка запроса к сервису
//
// Параметры:
//  АдресОтправки		- Строка	- дополнение адреса, куда отправить запрос
//  ПараметрыЗапроса	- Структура	- параметры отправляемого запроса 
//
// Возвращаемое значение:
//   Структура   - Признак успешного выполнения и описание ответа
//
Функция ОтправитьHTTPЗапрос(СтрокаПараметров)

	Результат			= Новый Структура("Успешно, Данные, ДанныеОбОшибке", 
											Ложь, 
											"",
											"");

	
	
	HTTPЗапрос				= Новый HTTPЗапрос;
	HTTPЗапрос.АдресРесурса = АдресЗапроса() + "?" + СтрокаПараметров;
	
	Попытка
		HTTPОтвет = СоединениеГА().Получить(HTTPЗапрос);			
	Исключение
		Результат.Успешно			= Ложь;
		Результат.ДанныеОбОшибке	= ИнформацияОбОшибке();
	КонецПопытки;
	Если HTTPОтвет.КодСостояния = 200 Тогда
		Результат.Успешно	= Истина;
		Результат.Данные	= HTTPОтвет.ПолучитьТелоКакСтроку();
	Иначе
		Результат.Успешно	= Ложь;
		Результат.ДанныеОбОшибке = HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
		
	Возврат Результат;

КонецФункции // ОтправитьHTTPЗапрос()

&НаКлиенте
Процедура ПереключитьРежимТестирования(РежимТестирования) Экспорт
	ПоместитьВоВХ("РежимТестирования", РежимТестирования);
	РежимТестирования = Неопределено;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ОбъектПараметрыКлиентСервер", Объект.ПараметрыКлиентСерверGA);
	
КонецПроцедуры
