#define FUNC_NORET	0x00000001L	// function doesn't return
			//не возвращает управление командой ret
#define FUNC_FAR	0x00000002L	// far function
			//функци€ возвращает управление инструкцией retf
#define FUNC_LIB	0x00000004L	// library function
			//библиотечна€ функци€
#define FUNC_STATIC	0x00000008L	// static function
			//статическа€ функци€
#define FUNC_FRAME	0x00000010L	// function uses frame pointer (BP)
			//функци€ использует дл€ регистр EBP дл€ указател€ 
			//на локальные переменные и параметры	
#define FUNC_USERFAR	0x00000020L	// user has specified far-ness
			//определена пользователем как далека€ (far)
#define FUNC_HIDDEN	0x00000040L	// a hidden function
			//скрыта€ (свернута€) функци€	
#define FUNC_THUNK	0x00000080L	// thunk (jump) function
			//функци€ Ц переходник, содержаща€ только 
			//инструкцию jmp
#define FUNC_BOTTOMBP	0x00000100L	// BP points to the bottom 
//of the stack frame
//регистр EBP указывает на Ђдної
//стекового фрейма			
