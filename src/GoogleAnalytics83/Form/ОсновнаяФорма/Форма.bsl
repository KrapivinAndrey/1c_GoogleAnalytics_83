﻿&НаКлиенте
Перем Гугл;

&НаКлиенте
Функция Гугл()
	Если ТипЗнч(Гугл) <> Тип("УправляемаяФорма") Тогда
		ИнициализироватьГуглАналитику()
	КонецЕсли;
	Гугл.НоваяСтруктураДанных();
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
	Гугл().Событие("ButtonTest", "click", "Не нажимать").ПоместитьВОчередь();
	Гугл().ОтправитьОчередьСобытий();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Гугл().ПереключитьРежимТестирования(Найти(ПараметрЗапуска, "debug") > 0);
	Гугл().ПросмотрЭкрана("ОсновнаяФорма")
			.ДобавитьПараметр("Имя конфигурации", "Тест")
			.ПоместитьВОчередь();
КонецПроцедуры
