#define FF_COMM 0x00000800L	// Has comment?
				// комментарий
#define FF_REF  0x00001000L	// has references?
				// перекрестна€ ссылка
#define FF_LINE 0x00002000L	// Has next or prev cmt lines ?
				// строка многострочного комментари€
#define FF_NAME 0x00004000L	// Has user-defined name ?
				// пользовательска€ метка (им€)
#define FF_LABL 0x00008000L	// Has dummy name?
				// метка (им€)
#define FF_FLOW 0x00010000L	// Exec flow from prev instruction?
				// перекрестна€ метка с предыдущей инструкции
#define FF_VAR  0x00080000L	// Is byte variable ?
				// переменна€ (метка дл€ данного)
