@echo off
echo.
echo Диски в DOSBox необязательно соответствуют реальным!
echo Буквы X:, Y:, Z: зарезервированы! См. инструкцию
echo   Y: в Portable версии соответствует "prg"
echo.
echo Специальные комбинации клавиш:
echo Ctrl-F11 ── повторно сканировать все диски
echo     это нужно, если в DOSBox не видно новые файлы
echo Alt-F11 ── вернуть управление мышью в Windows
echo Alt-Enter ── развернуть DOSBox на весь экран
echo Ctrl-F12 ── прибить окно DOSBox
echo     потеряв несохранённые изменения
echo Правый Ctrl ── переключение русский/английский
echo.
if X%scshcut% == Xtp echo Нажмите Alt-F5, чтобы просмотреть весь экран пользователя
if X%scshcut% == Xshell echo Введите tp, чтобы запустить Turbo Pascal
if X%scshcut% == Xshell echo         nc, чтобы запустить Norton Commander
if X%scshcut% == Xnc echo Нажмите Ctrl-O, чтобы показать/убрать панели
if X%scshcut% == Xnc echo Нажмите Alt-F1, чтобы выбрать другой диск