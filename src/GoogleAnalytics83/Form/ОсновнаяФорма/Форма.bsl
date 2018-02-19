﻿&НаКлиенте
Перем Гугл;

&НаКлиенте
Функция Гугл()
	Если ТипЗнч(Гугл) <> Тип("УправляемаяФорма") Тогда
		ИнициализироватьГуглАналитику()
	КонецЕсли;
	Возврат Гугл;
КонецФункции

&НаКлиенте
Процедура ИнициализироватьГуглАналитику()
	ПараметрыФормы		= Новый Структура;
	ПараметрыФормы.Вставить("ОбъектПараметрыКлиентСервер", Объект.ПараметрыКлиентСерверGA);
	ПолныйПутьКФорме	= Объект.ПараметрыКлиентСерверGA.ПутьКФормам + "GoogleAnalytics";
	
	Гугл			= ПолучитьФорму(ПолныйПутьКФорме, ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбработикаОбъект = РеквизитФормыВЗначение("Объект");
	Объект.ПараметрыКлиентСерверGA = ОбработикаОбъект.ИнициализироватьПараметрыКлиентСервер(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НеНажимать(Команда)
	Гугл().ОтправитьСобытие("ButtonTest", "click", "Не нажимать");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Гугл().ПереключитьРежимТестирования(Найти(ПараметрЗапуска, "debug") > 0);
КонецПроцедуры
