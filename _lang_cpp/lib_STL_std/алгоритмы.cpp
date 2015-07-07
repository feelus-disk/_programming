//поэлементная
for_each								.	x		//выполнить со всем массивом
//поэлементные не меняющие
find			_if, c++11)_if_not		  .	strchr..//найти символ в строке
с++11)*of		all_, any_, none_		...	x		//тру - если все тру, тру 0 если хоть какой-нибудь тру, тру - если все фолс
count			_if						.			//посчитать количество символов, равных данному
find_first_of+							.			//найти в массиве1 какой-нибудь символ из массива2 //strpbrk
mismatch+								...			//место несовпадения в массивах
equal+									...	strcmp..//равны ли массивы
lexicographical_compare+				...	strcmp..//лексикографическое сравнение
//поэлементные меняющие
iter_swap, swap										//обмен 2 элементов
swap_ranges								.			//обмен 2 элементов последовательно в массивах
copy			_backward, c++11)_n, _if../2 strcpy	//копирует один массив в другой
c++11)move		_backward							//как copy, только вырезает
transform 								.			//преобразовать посимвольно одну строку в другую
replace			_if, _copy, _copy_if	.			//заменить один исмвол другим
fill			_n									//заполняет
generate		_n									//заполнить массив результатом данной функции
//не меняющие
adjacent_find+							.			//найти первые повторяющиеся символы
search_n+								.			//найти первые н символов равных данному в строке
search+									.	strstr..//найти первую подстроку в строке
find_end+								.	strpbrk.//найти последнюю подстроку в строке
//меняющие
reverse			_copy								//разворачивает массив
rotate			_copy								//циклический сдвиг
remove			_if, _copy, _copy_if	.			//удаляет символы, равные данному
unique+			_copy+					.			//удаляет повторяющиеся символы, оставляя одиночные
//сортировка
min, max, c++11)minmax
*element		max_, min_, c++11)minmax_			.	//максимум, минимум
partition		stable_, c++11)_copy					//сортирует элементы массива на 2 группы
c++11)is_partitioned									
c++11)partition_point									
sort+			stable_+, partial_+, partial__copy+		//сортировка
c++11)is_sorted+	_until+
nth_element+											//поставить нй элемент на ное место
//работа с отсортированным
lower_bound+, upper_bound+, equal_range+, binary_search+//двоичный поиск
merge			inplace_							./2	//слияние
includes+, set*	_union+, _intersection+,
	_difference+, _symmetric_difference+			.	//работа с отсортированными множествами
//разное
*heap			push_+, pop_+, make_+, sort_+			//куча
c++11)is_heap+	_until+
*permutation	next_+, prew+							//перестановки
c++11)is_permutation+									//является ли один массив перестановкой другого
random_shuffle	c++11)shuffle							//случайные перестановки
-----

Алгоритмы
Не меняющие последовательность операции (Non-mutating sequence operations)
	Операции с каждым элементом (For each)
		func 	for_each(In first, In last, func);
	Найти (Find)
		In 		find			(In 	first, 	In 	last, 						const T& value);
		In 		find_if			(In 	first, 	In 	last, 						Predicate pred);
	Найти рядом (Аdjacent find)
		For 	adjacent_find	(For 	first, 	For last						);
		For 	adjacent_find	(For 	first, 	For last,  						BinaryPredicate binary_pred);
	Подсчет (Count)
		void 	count			(In 	first, 	In 	last, 						const T& value, Size& n);
		void 	count_if		(In 	first, 	In 	last, 						Predicate pred, Size& n);
	Отличие (Mismatch)
		pair<In1, In2> mismatch	(In1 	first1,	In1 last1, 	In2 first2);
		pair<In1, In2> mismatch	(In1 	first1,	In1 last1, 	In2 first2,			BinaryPredicate binary_pred);
	Сравнение на равенство (Equal)
		bool 	equal			(In1 	first1,	In1 last1, 	In2 first2);
		bool 	equal			(In1 	first1,	In1 last1, 	In2 first2,      	BinaryPredicate binary_pred);
	Поиск подпоследовательности (Search)
		For1 	search			(For1 	first1,	For1 last1,	For2 first2, For2 last2);
		For1 	search			(For1 	first1,	For1 last1, For2 first2, For2 last2,     BinaryPredicate binary_pred);
Меняющие последовательность операции (Mutating sequence operations)
	Копировать (Copy)
		Out 	copy			(In 	first,	In 	last,	Out result			);
		Bid2 	copy_backward	(Bid1 	first,	Bid1 last,	Bid2 result			);
	Обменять (Swap)
		void 	swap(T& a, T& b);
		void 	iter_swap		(For1 	a, 		For2 b);
		For2 	swap_ranges		(For1 first1,	For1 last1, For2 first2);
	Преобразовать (Transform)
		Out 	transform		(In 	first, 	In 	last, 				Out result, UnaryOperation op);
		Out 	transform		(In1 	first1, In1 last1, 	In2 first2, Out result,	BinaryOperation binary_op);
	Заменить (Replace)
		void 	replace			(For 	first, 	For last, 					const T& old_value, const T& new_value);
		void 	replace_if		(For 	first, 	For last, 					Predicate pred,     const T& new_value);
		Out 	replace_copy	(In 	first, 	In 	last,	Out result, 	const T& old_value, const T& new_value);
		Out 	replace_copy_if	(It 	first, 	It 	last,	Out result, 	Predicate pred, 	const T& new_value);
	Заполнить (Fill)
		void 	fill			(For 	first, 	For last, 						const T& value);
		Out 	fill_n			(Out 	first, 		Size n, 					const T& value);
	Породить (Generate)
		void 	generate		(For 	first, 	For last,     					Generator gen);
		Out 	generate_n		(Out 	first, 		Size n, 					Generator gen);
	Удалить (Remove)
		For 	remove			(For 	first, 	For last,     					const T& value);
		For 	remove_if		(For 	first, 	For last,						Predicate pred);
		Out 	remove_copy		(In 	first, 	In 	last, 	Out result, 		const T& value);
		Out 	remove_copy_if	(In 	first, 	In 	last, 	Out result, 		Predicate pred);
	Убрать повторы (Unique)
		For 	unique			(For 	first, 	For last						);
		For 	unique			(For 	first, 	For last,     					BinaryPredicate binary_pred);
		Out 	unique_copy		(In 	first, 	In 	last, 	Out result			);
		Out 	unique_copy		(In 	first, 	In 	last, 	Out result, 		BinaryPredicate binary_pred);
	Расположить в обратном порядке (Reverse)
		void 	reverse			(Bid 	first,	Bid last						);
		Out 	reverse_copy	(Bid 	first,	Bid last, 	Out result			);
	Переместить по кругу (Rotate)
		void 	rotate			(For 	first, 	For middle, For last);
		Out 	rotate_copy		(For 	first, 	For middle, For last, 	Out result);
	Перетасовать (Random shuffle)
		void 	random_shuffle	(Rand 	first, 	Rand last						);
		void 	random_shuffie	(Rand 	first, 	Rand last, 						RandomNumberGenerator& rand);
	Разделить (Partitions)
		Bid 	partition		(Bid 	first, 	Bid last, 						Predicate pred);
		Bid 	stable_partition(Bid 	first, 	Bid last, 						Predicate pred);
Операции сортировки и отношения (Sorting and related operations)
	Сортировка (Sort)
		void 	sort			(Rand 	first, 	Rand last						);
		void 	sort			(Rand 	first, 	Rand last,     					Compare comp);
		void 	stable_sort		(Rand 	first, 	Rand last						);
		void 	stable_sort		(Rand 	first, 	Rand last, 						Compare comp);
		void 	partial_sort	(Rand 	first, 	Rand middle,	Rand last		);
		void 	partial_sort	(Rand 	first, 	Rand middle,	Rand last, 		Compare comp);
		Rand 	partial_sort_copy(In 	first, 	In 	last, 		Rand result_first, Rand result_last);
		Rand 	partial_sort_copy(In 	first, 	In 	last, 		Rand result_first, Rand result_last, Compare comp);
	N-й элемент (Nth element)
		void 	nth_element		(Rand 	first, 	Rand nth,		Rand last		);
		void 	nth_element		(Rand 	first, 	Rand nth, 		Rand last, 		Compare comp);
	Двоичный поиск (Binary search)
		For 	lower_bound		(For 	first, 	For last,     					const T& value);
		For 	lower_bound		(For 	first, 	For last, 						const T& value, Compare comp);
		For 	upper_bound		(For 	first, 	For last, 						const T& value);
		For  	upper_bound		(For 	first, 	For last, 						const T& value, Compare comp);
		For 	equal_range		(For 	first, 	For last, 						const T& value);
		For 	equal_range		(For 	first, 	For last, 						const T& value, Compare comp);
		For 	binary_search	(For 	first, 	For last, 						const T& value);
		For 	binary_search	(For	first,	For last, 						const T& value, ...
	Объединение (Merge)
		Out 	merge			(In1 	first1, In1 last1, 	In2 first2, In2 last2, Out result);
		Out 	merge			(In1 	first1, In1 last1, 	In2 first2, In2 last2, Out result, Compare comp);
		void 	inplace_merge	(Bid 	first, 	Bid middle, Bid last			);

	Операции над множеством для сортированных структур (Set operations on sorted structures)
	Операции над пирамидами (Heap operations)
	Минимум и максимум (Minimum and maximum)
	Лексикографическое сравнение (Lexicographical comparison)
	Генераторы перестановок (Permutation generators)
Обобщённые численные операции (Generalized numeric operations)
	Накопление (Accumulate)
	Скалярное произведение (Inner product)
	Частичная сумма (Partial sum)
	Смежная разность (Adjacent difference)
----------------------------------------------
{Не меняющие последовательность операции (Non-mutating sequence operations)
{Операции с каждым элементом (For each)

template <class InputIterator, class Function>
Function for_each(InputIterator first, InputIterator last, Function f);

for_each применяет f к результату разыменования каждого итератора 
в диапазоне [first, last) и возвращает f.
Принято, что f не применяет какую-то непостоянную функцию к разыменованному итератору.
f применяется точно last-first раз.
Если f возвращает результат, результат игнорируется.
}
{Найти (Find)

template <class InputIterator, class T>
InputIterator find(InputIterator first, InputIterator last, const T& value);

template <class InputIterator, class Predicate>
InputIterator find_if(InputIterator first, InputIterator last, Predicate pred);

find возвращает первый итератор i в диапазоне [first, last),
для которого соблюдаются следующие соответствующие условия:
*i == value, pred (*i) == true.
Если такой итератор не найден, возвращается last.
Соответствующий предикат применяется точно find(first, last, value) - first раз.
}
{Найти рядом (Аdjacent find)

template <class ForwardIterator>
ForwardIterator adjacent_find(ForwardIterator first, ForwardIterator last);

template <class ForwardIterator, class BinaryPredicate>
ForwardIterator adjacent_find(ForwardIterator first, ForwardIterator last,
         BinaryPredicate binary_pred);

adjacent_find возвращает первый итератор i такой, что i и i+1 находятся в диапазоне [first, last)
и для которого соблюдаются следующие соответствующие условия:
*i == *(i + 1), binary_pred(*i, *(i + 1)) == true.
Если такой итератор i не найден, возвращается last.
Соответствующий предикат применяется, самое большее, max((last - first) - 1, 0) раз.
}
{Подсчет (Count)

template <class InputIterator, class T, class Size>
void count(InputIterator first, InputIterator last, const T& value, Size& n);

template <class InputIterator, class Predicate, class Size>
void count_if(InputIterator first, InputIterator last, Predicate pred, Size& n);

count добавляет к n число итераторов i в диапазоне [first, last),
для которых соблюдаются следующие соответствующие условия:
*i == value, pred (*i) == true.
Соответствующий предикат применяется точно last-first раз.

count должен сохранять результат в параметре ссылки вместо того, чтобы возвращать его,
потому что тип размера не может быть выведен из встроенных типов итераторов, как, например, int*.
}
{Отличие (Mismatch)

template <class InputIterator1, class InputIterator2>
pair<InputIterator1, InputIterator2> mismatch(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2);

template <class InputIterator1, class InputIterator2, class BinaryPredicate>
pair<InputIterator1, InputIterator2> mismatch(InputIterator1 first1,
    InputIterator1 last1, InputIterator2 first2,
    BinaryPredicate binary_pred);

mismatch возвращает пару итераторов i и j таких, что
j == first2 + (i - first1) и i является первым итератором в диапазоне [first1, last1),
для которого следующие соответствующие условия выполнены:
!(*i == *(first2 + (i - first1))), binary_pred (*i, *(first2 + (i - first1))) == false.
Если такой итератор i не найден, пара last1 и first2 + (last1 - first1) возвращается.
Соответствующий предикат применяется, самое большее, last1 - first1 раз.
}
{Сравнение на равенство (Equal)

template <class InputIterator1, class InputIterator2>
bool equal(InputIterator1 first1, InputIterator1 last1, InputIterator2 first2);

template <class InputIterator1, class InputIterator2, class BinaryPredicate>
bool equal(InputIterator1 first1, InputIterator1 last1, InputIterator2 first2, 
        BinaryPredicate binary_pred);

equal возвращает true, если для каждого итератора i в диапазоне [first1, last1) выполнены следующие соответствующие условия:
*i == *(first2 + (i - first1)), binary_pred(*i, *(first2 + (i - first1))) == true.
Иначе equal возвращает false.
Соответствующий предикат применяется, самое большее, last1 - first1 раз.
}
{Поиск подпоследовательности (Search)

template <class ForwardIterator1, class ForwardIterator2>
ForwardIterator1 search(ForwardIterator1 first1, ForwardIterator1 last1, 
    ForwardIterator2 first2, ForwardIterator2 last2);

template <class ForwardIterator1, class ForwardIterator2, 
    class BinaryPredicate>
ForwardIterator1 search(ForwardIterator1 first1, ForwardIterator1 last1, 
    ForwardIterator2 first2, ForwardIterator2 last2, 
    BinaryPredicate binary_pred);

search находит подпоследовательность равных значений в последовательности.
search возвращает первый итератор i в диапазоне [first1, last1 - (last2 - first2)) такой, что
для любого неотрицательного целого числа n, меньшего чем last2 - first2, выполнены следующие соответствующие условия:
*(i + n) == *(first2 + n), binary_pred(*(i + n), *(first2 + n)) == true.
Если такой итератор не найден, возвращается last1.
Соответствующий предикат применяется, самое большее, (last1 - first1) * (last2 - first2) раз.
Квадратичное поведение, однако, является крайне маловероятным.
}
}
{Меняющие последовательность операции (Mutating sequence operations)
{Копировать (Copy)

template <class InputIterator, class OutputIterator> 
OutputIterator copy(InputIterator first, InputIterator last, 
    OutputIterator result);

copy копирует элементы. Для каждого неотрицательного целого числа n < (last - first) выполняется присваивание *( result + n) = *( first + n). Точно делается last - first присваиваний. Результат copy не определён, если result находится в диапазоне [first, last).

template <class BidirectionalIterator1, class BidirectionalIterator2>
BidirectionalIterator2 copy_backward(BidirectionalIterator1 first,
    BidirectionalIterator1 last, BidirectionalIterator2 result);

copy_backward копирует элементы в диапазоне [first, last) в диапазон [result - (last - first), result), начиная от last-1 и продолжая до first. Его нужно использовать вместо copy, когда last находится в диапазоне [result - (last - first), result). Для каждого положительного целого числа n <= (last - first) выполняется присваивание *(result - n) = *(last - n). copy_backward возвращает result - (last - first). Точно делается last - first присваиваний. Результат copy_backward не определён, если result находится в диапазоне [first, last).
}
{Обменять (Swap)

template <class T> 
void swap(T& a, T& b);

swap обменивает значения, хранимые в двух местах.

template <class ForwardIterator1, class ForwardIterator2>
void iter_swap(ForwardIterator1 a, ForwardIterator2 b);

iter_swap обменивает значения, указанные двумя итераторами a и b.

tempate <class ForwardIterator1, class ForwardIterator2>
ForwardIterator2 swap_ranges(ForwardIterator1 first1, 
    ForwardIterator1 last1, ForwardIterator2 first2);

Для каждого неотрицательного целого числа n < (last1 - first1) выполняется перестановка: swap(*(first1 + n), *(first2 + n)). swap_ranges возвращает first2 + (last1 - first1). Выполняется точно last1 - first1 перестановок. Результат swap_ranges не определён, если два диапазона [first1, last1) и [first2, first2 + (last1 - first1)) перекрываются.
}
{Преобразовать (Transform)

template  <class InputIterator, class OutputIterator, class Unary0peration> 
OutputIterator transform(InputIterator first, InputIterator last, 
    OutputIterator result, UnaryOperation op);

template  <class InputIterator1, class InputIterator2, 
    class OutputIterator, class Binary0peration> 
OutputIterator transform(InputIterator1 first1, InputIterator1 last1, 
    InputIterator2 first2, OutputIterator result,
    BinaryOperation binary_op);
	
transform присваивает посредством каждого итератора i в диапазоне [result, result + (last1 - first1))
новое соответствующее значение, равное op(* (first1 + (i - result)) или binary_op(*(first1 + (i - result), *(first2 + (i - result))).
transform возвращает result + (last1 - first1).
Применяются op или binary_op точно last1 - first1 раз.
Ожидается, что op и binary_op не имеют каких-либо побочных эффектов.
result может быть равен first в случае унарного преобразования или first1 либо first2 в случае бинарного.
}
{Заменить (Replace)

template <class ForwardIterator, class T>
void replace(ForwardIterator first, ForwardIterator last, const T& old_value, 
    const T& new_value);

template <class ForwardIterator, class Predicate, class T>
void replace_if(ForwardIterator first, ForwardIterator last, Predicate pred, 
    const T& new_value);

replace заменяет элементы, указанные итератором i в диапазоне [first, last), значением new_value, когда выполняются следующие соответствующие условия: *i == old_value, pred(*i) == true. Соответствующий предикат применяется точно last - first раз.

template <class InputIterator, class OutputIterator, class T> 
OutputIterator replace_copy(InputIterator first, InputIterator last,
    OutputIterator result, const T& old_value, const T& new_value);

template <class Iterator, class OutputIterator, class Predicate, class T> 
OutputIterator replace_copy_if(Iterator first, Iterator last,
    OutputIterator result, Predicate pred, const T& new_value);

replace_copy присваивает каждому итератору i в диапазоне [result, result + (last - first)) значение new_value или *(first + (i - result)) в зависимости от выполнения следующих соответствующих условий: *(first + (i - result)) == old_value, pred(*(first + (i - result))) == true. replace_copy возвращает result + (last - first). Соответствующий предикат применяется точно last - first раз.
}
{Заполнить (Fill)

template <class ForwardIterator, class T> 
void fill(ForwardIterator first, ForwardIterator last, const T& value);

template <class OutputIterator, class Size, class T>
OutputIterator fill_n(Output Iterator first, Size n, const T& value);

fill присваивает значения через все итераторы в диапазоне [first, last) или [first, first + n). fill_n возвращает first + n. Точно делается last - first (или n) присваиваний.
}
{Породить (Generate)

template <class ForwardIterator, class Generator> 
void generate(ForwardIterator first, ForwardIterator last, 
    Generator gen);

template <class OutputIterator, class Size, class Generator> 
OutputIterator generate_n(OutputIterator first, Size n, Generator gen);

generate вызывает функциональный объект gen и присваивает возвращаемое gen значение
через все итераторы в диапазоне [first, last) или [first, first + n).
gen не берёт никакие параметры.
generate_n возвращает first + n.
Точно выполняется last - first (или n) вызовов gen и присваиваний.
}
{Удалить (Remove)

template <class ForwardIterator, class T>
ForwardIterator remove(ForwardIterator first, ForwardIterator last, 
    const T& value);

template <class ForwardIterator, class Predicate>
ForwardIterator remove_if(ForwardIterator first, ForwardIterator last, 
    Predicate pred);

remove устраняет все элементы, указываемые итератором i в диапазоне [first, last), для которых выполнены следующие соответствующие условия:
*i == value, pred (*i) == true.
remove возвращает конец возникающего в результате своей работы диапазона.
remove устойчив, то есть относительный порядок элементов, которые не удалены, такой же, как их относительный порядок в первоначальном диапазоне.
Соответствующий предикат применяется точно last -first раз.

template <class InputIterator, class OutputIterator, class T> 
OutputIterator remove_copy(InputIterator first, InputIterator last, 
    OutputIterator result, const T& value);

template <class InputIterator, class OutputIterator, class Predicate> 
OutputIterator remove_copy_if(InputIterator first, InputIterator last, 
    OutputIterator result, Predicate pred);

remove_copy копирует все элементы, указываемые итератором i в диапазоне [first, last), для которых не выполнены следующие соответствующие условия:*i == value, pred (*i) == true. remove_copy возвращает конец возникающего в результате своей работы диапазона. remove_copy устойчив, то есть относительный порядок элементов в результирующем диапазоне такой же, как их относительный порядок в первоначальном диапазоне. Соответствующий предикат применяется точно last - first раз.
}
{Убрать повторы (Unique)

template <class ForwardIterator>
ForwardIterator unique(ForwardIterator first, ForwardIterator last);

template <class ForwardIterator, class BinaryPredicate>
ForwardIterator unique(ForwardIterator first, ForwardIterator last, 
    BinaryPredicate binary_pred);
	
unique устраняет все, кроме первого, элементы из каждой последовательной группы равных элементов,
указываемые итератором i в диапазоне [first, last), для которых выполнены следующие соответствующие условия:
*i == *(i - 1) или binary_pred(*i, *(i - 1)) == true.
unique возвращает конец возникающего в результате диапазона.
Соответствующий предикат применяется точно (last - first) - 1 раз.

template <class InputIterator, class OutputIterator> 
OutputIterator unique_copy(InputIterator first, InputIterator last, 
    OutputIterator result);

template <class InputIterator, class OutputIterator, 
    class BinaryPredicate>
OutputIterator unique_copy(InputIterator first, InputIterator last, 
    OutputIterator result, BinaryPredicate binary_pred);
	
unique_copy копирует только первый элемент из каждой последовательной группы равных элементов, указываемых итератором i в диапазоне [first, last), для которых выполнены следующие соответствующие условия: *i == *(i - 1) или binary_pied(*i, *(i - 1)) == true. unique_copy возвращает конец возникающего в результате диапазона. Соответствующий предикат применяется точно (last - first) - 1 раз.
}
{Расположить в обратном порядке (Reverse)

template <class BidirectionalIterator>
void reverse(BidirectionalIterator first, 
    BidirectionalIterator last);
	
Для каждого неотрицательного целого числа i <= (last - first)/2 функция reverse применяет перестановку ко всем парам итераторов first + i, (last - i) - 1. Выполняется точно (last - first)/2 перестановок.

template <class BidirectionalIterator, class OutputIterator> 
OutputIterator reverse_copy(BidirectionalIterator first,
    BidirectionalIterator last, OutputIterator result);
	
reverse_copy копирует диапазон [first, last) в диапазон [result, result + (last - first)) такой, что для любого неотрицательного целого числа i < (last - first) происходит следующее присваивание: *(result + (last - first) - i) = *(first + i). reverse_copy возвращает result + (last - first). Делается точно last - first присваиваний. Результат reverse_copy не определён, если [first, last) и [result, result + (last - first)) перекрываются.
}
{Переместить по кругу (Rotate)

template <class ForwardIterator> 
void rotate(ForwardIterator first, ForwardIterator middle, 
    ForwardIterator last);
	
Для каждого неотрицательного целого числа i < (last - first) функция rotate помещает элемент из позиции first + i в позицию first + (i + (last - middle)) % (last - first). [first, middle) и [middle, last) - допустимые диапазоны. Максимально выполняется last - first перестановок.

template <class ForwardIterator, class OutputIterator>
OutputIterator rotate_copy(ForwardIterator first, ForwardIterator middle, 
    ForwardIterator last, OutputIterator result);
	
rotate_copy копирует диапазон [first, last) в диапазон [result, result + (last - first)) такой, что для каждого неотрицательного целого числа i < (last - first) происходит следующее присваивание: *(result + (i + (last - middle)) % (last - first)) = *(first + i). rotate_copy возвращает result + (last - first). Делается точно last - first присваиваний. Результат rotate_copy не определён, если [first, last) и [result, result + (last - first)) перекрываются.
}
{Перетасовать (Random shuffle)

template <class RandomAccessIterator>
void random_shuffle(RandomAccessIterator first, RandomAccessIterator last);

template <class RandomAccessIterator, class RandomNumberGenerator>
void random_shuffie(RandomAccessIterator first, RandomAccessIterator last, 
    RandomNumberGenerator& rand);
	
random_shuffle переставляет элементы в диапазоне [first, last) с равномерным распределением.
Выполняется точно last - first перестановок.
random_shuffle может брать в качестве параметра особый генерирующий случайное число функциональный
объект rand такой, что rand берёт положительный параметр n типа расстояния RandomAccessIterator и возвращает случайно выбранное значение между 0 и n-1.
}
{Разделить (Partitions)

template <class BidirectionalIterator, class Predicate> 
BidirectionalIterator partition(BidirectionalIterator first, 
    BidirectionalIterator last, Predicate pred);
	
partition помещает все элементы в диапазоне [first, last),
которые удовлетворяют pred, перед всеми элементами, которые не удовлетворяют.
Возвращается итератор i такой, что для любого итератора j в диапазоне [first, i) будет pred (*j) == true,
а для любого итератора k в диапазоне [i, last) будет pred(*k) == false.
Делается максимально (last - first)/2 перестановок.
Предикат применяется точно last - first раз.

template <class BidirectionalIterator, class Predicate>
BidirectionalIterator stable_partition(BidirectionalIterator first, 
    BidirectionalIterator last, Predicate pred);
	
stable_partition помещает все элементы в диапазоне [first, last), которые удовлетворяют pred, перед всеми элементами, которые не удовлетворяют. Возвращается итератор i такой, что для любого итератора j в диапазоне [first, i) будет pred(*j) == true, а для любого итератора k в диапазоне [i, last) будет pred(*k) == false. Относительный порядок элементов в обеих группах сохраняется. Делается максимально (last - first) * log(last - first) перестановок, но только линейное число перестановок, если имеется достаточная дополнительная память. Предикат применяется точно last - first раз.
}
}
{Операции сортировки и отношения (Sorting and related operations)
Все операции в этом разделе имеют две версии: одна берёт в качестве параметра функциональный объект типа Compare, а другая использует operator< .

Compare - функциональный объект, который возвращает значение, обратимое в bool. Compare comp используется полностью для алгоритмов, принимающих отношение упорядочения. comp удовлетворяет стандартным аксиомам для полного упорядочения и не применяет никакую непостоянную функцию к разыменованному итератору. Для всех алгоритмов, которые берут Compare, имеется версия, которая использует operator< взамен. То есть comp(*i, *j) == true по умолчанию для *i < *j == true.

Последовательность сортируется относительно компаратора comp, если для любого итератора i, указывающего на элемент в последовательности, и любого неотрицательного целого числе n такого, что i + n является допустимым итератором, указывающим на элемент той же самой последовательности, comp(*( i + n), *i) == false.

В описаниях функций, которые имеют дело с упорядочивающими отношениями, мы часто используем представление равенства, чтобы описать такие понятия, как устойчивость. Равенство, к которому мы обращаемся, не обязательно operator==, а отношение равенства стимулируется полным упорядочением. То есть два элементa a и b считаются равными, если и только если !(a < b) && !(b < a).
{Сортировка (Sort)

template <class RandomAccessIterator>
void sort(RandomAccessIterator first, RandomAccessIterator last);

template <class RandomAccessIterator, class Compare> 
void sort(RandomAccessIterator first, RandomAccessIterator last, 
    Compare comp);
	
sort сортирует элементы в диапазоне [first, last). Делается приблизительно NIogN (где N равняется last - first) сравнений в среднем. Если режим наихудшего случая важен, должны использоваться stable_sort или partial_sort.

template <class RandomAccessIterator>
void stable_sort(RandomAccessIterator first, RandomAccessIterator last);

template <class RandomAccessIterator, class Compare> 
void stable_sort(RandomAccessIterator first, RandomAccessIterator last, 
    Compare comp);
	
stable_sort сортирует элементы в диапазоне [first, last). Он устойчив, то есть относительный порядок равных элементов сохраняется. Делается максимум N(logN)2 (гдеN равняется last - first) сравнений; если доступна достаточная дополнительная память, тогда зто - NlogN.

template <class RandomAccessIterator>
void partial_sort(RandomAccessIterator first, RandomAccessIterator middle,
     RandomAccessIterator last);

template <class RandomAccessIterator, class Compare>
void partial_sort(RandomAccessIterator first, RandomAccessIterator middle,
     RandomAccessIterator last, Compare comp);

partial_sort помещает первые middle - first сортированных элементов из диапазона [first, last) в диапазон [first, middle). Остальная часть элементов в диапазоне [middle, last) помещена в неопределённом порядке. Берётся приблизительно (last - first) * log(middle - first) сравнений.

template <class InputIterator, class RandomAccessIterator>
RandomAccessIterator partial_sort_copy(InputIterator first, 
    InputIterator last, RandomAccessIterator result_first, 
    RandomAccessIterator result_last);

template <class InputIterator, class RandomAccessIterator, 
    class Compare> 
RandomAccessIterator partial_sort_copy(InputIterator first, 
    InputIterator last, RandomAccessIterator result_first, 
    RandomAccessIterator result_last, Compare comp);

partial_sort_copy помещает первые min(last - first, result_last - result_first) сортированных элементов в диапазон [result_first, result_first + min(last - first, result_last - result_first)). Возвращается или result_last, или result_first +(last - first), какой меньше. Берётся приблизительно (last - first) * log(min(last - first, result_last - result_first)) сравнений.
}
{N-й элемент (Nth element)

template <class RandomAccessIterator>
void nth_element(RandomAccessIterator first, RandomAccessIterator nth,
     RandomAccessIterator last);

template <class RandomAccessIterator, class Compare>
void nth_element(RandomAccessIterator first, RandomAccessIterator nth, 
    RandomAccessIterator last, Compare comp);
	
После операции nth_element элемент в позиции, указанной nth, является элементом,
который был бы в той позиции, если бы сортировался целый диапазон.
Также для любого итератора i в диапазоне [first, nth) и любого итератора j в диапазоне [nth, last) считается, что !(*i > *j) или comp(*i, *j) == false. Операция линейна в среднем.
}
{Двоичный поиск (Binary search)

Все алгоритмы в этом разделе - версии двоичного поиска.
Они работают с итераторами не произвольного доступа, уменьшая число сравнений, которое будет логарифмическим для всех типов итераторов.
Они особенно подходят для итераторов произвольного доступа, так как эти алгоритмы делают логарифмическое число шагов в структуре данных.
Для итераторов не произвольного доступа они выполняют линейное число шагов.

template <class ForwardIterator, class T>
ForwardIterator lower_bound(ForwardIterator first, ForwardIterator last, 
    const T& value);

template <class ForwardIterator, class T, class Compare>  
ForwardIterator lower_bound(ForwardIterator first, 
    ForwardIterator last, const T& value, Compare comp);
	
lower_bound находит первую позицию, в которую value может быть вставлено без нарушения упорядочения. lower_bound возвращает самый дальний итератор i в диапазоне [first, last) такой, что для любого итератора j в диапазоне [first, i) выполняются следующие соответствующие условия: *j < value или comp(*j, value) == true. Делается максимум log(last - first) + 1 сравнений.

template <class ForwardIterator, class T>
ForwardIterator upper_bound(ForwardIterator first, 
    ForwardIterator last, const T& value);

template <class ForwardIterator, class T, class Compare>
ForwardIterator  upper_bound(ForwardIterator first, 
    ForwardIterator last, const T& value, Compare comp);
	
upper_bound находит самую дальнюю позицию, в которую value может быть вставлено без нарушения упорядочения. upper_bound возвращает самый дальний итератор i в диапазоне [first, last) такой, что для любого итератора j в диапазоне [first, i) выполняются следующие соответствующие условия: !(value < *j) или comp(value, *j) == false. Делается максимум log(last - first) + 1 сравнений.

template <class ForwardIterator, class T>
ForwardIterator equal_range(ForwardIterator first, 
    ForwardIterator last, const T& value);

template <class ForwardIterator, class T, class Compare>  
ForwardIterator equal_range(ForwardIterator first, 
    ForwardIterator last, const T& value, 
    Compare comp);
	
equal_range находит самый большой поддиапазон [i, j) такой, что значение может быть вставлено по любому итератору k в нём. k удовлетворяет соответствующим условиям: !(*k < value) && !(value < *k) или comp(*k, value) == false && comp(value, *k) == false. Делается максимум 2 * log(last - first) + 1 сравнений.

template <class ForwardIterator, class T>
ForwardIterator binary_search(ForwardIterator first, 
    ForwardIterator last, const T& value);

template <class ForwardIterator, class T, class Compare>
ForwardIterator binary_search(ForwardIterator first, 
    ForwardIterator last, const T& value,
	
binary_search возвращает истину, если в диапазоне [first, last) имеется итератор i, который удовлетворяет соответствующим условиям: !(*i < value) && !(value < *i) или comp(*i, value) == false && comp(value, *i) == false. Делается максимум log(last - first) + 2 сравнений.
}
{Объединение (Merge)

template <class InputIterator1, class Input Iterator2, 
    class OutputIterator>
OutputIterator merge(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator result);

template <class InputIterator1, class InputIterator2, 
    class OutputIterator, class Compare> 
OutputIterator merge(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator result, 
    Compare comp);
	
merge объединяет два сортированных диапазона [first1, last1) и [first2, last2) в диапазон [result, result + (last1 - first1) + (last2 - first2)).
Объединение устойчиво, то есть для равных элементов в двух диапазонах элементы из первого диапазона всегда предшествуют элементам из второго.
merge возвращает result + (last1 - first1) + (last2 - first2).
Выполняется максимально (last1 - first1) + (last2 - first2) - 1 сравнений.
Результат merge не определён, если возникающий в результате диапазон перекрывается с любым из первоначальных диапазонов.

template <class BidirectionalIterator>
void inplace_merge(BidirectionalIterator first, 
    BidirectionalIterator middle, 
    BidirectionalIterator last);

template <class BidirectionalIterator, class Compare>
void inplace_merge(BidirectionalIterator first, 
    BidirectionalIterator middle, 
    BidirectionalIterator last, 
    Compare comp);
	
inplace_merge объединяет два сортированных последовательных диапазона [first, middle) и [middle, last), помещая результат объединения в диапазон [first, last). Объединение устойчиво, то есть для равных элементов в двух диапазонах элементы из первого диапазона всегда предшествуют элементам из второго. Когда доступно достаточно дополнительной памяти, выполняется максимально (last - first) - 1 сравнений. Если никакая дополнительная память не доступна, может использоваться алгоритм со сложностью O(NlogN).
}
{Операции над множеством для сортированных структур (Set operations on sorted structures)

Этот раздел определяет все основные операции над множеством для сортированных структур.
Они даже работают с множествами с дубликатами, содержащими множественные копии равных элементов.
Семантика операций над множеством обобщена на множества с дубликатами стандартным способом,
определяя объединение, содержащее максимальное число местонахождений каждого элемента, пересечение, содержащее минимум, и так далее.

template <class InputIterator1, class InputIterator2>
bool includes(InputIterator1 first1, InputIterator1 last1, 
    InputIterator2 first2, InputIterator2 last2);

template <class InputIterator1, class InputIterator2, 
    class Compare>
bool includes(InputIterator1 first1, InputIterator1 last1, 
    InputIterator2 first2, InputIterator2 last2, 
    Compare comp);
includes возвращает true, если каждый элемент в диапазоне [first2, last2) содержится в диапазоне [first1, last1). Иначе возвращается false. Выполняется максимально ((last1 - first1) + (last2 - first2)) * 2 - 1 сравнений.

template <class InputIterator1, class InputIterator2, 
    class OutputIterator>
OutputIterator set_union(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator result);

template <class InputIterator1, class InputIterator2, 
    class OutputIterator, class Compare>
OutputIterator set_union(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator result, 
    Compare comp);
set_union создаёт сортированное объединение элементов из двух диапазонов.
Он возвращает конец созданного диапазона.
Выполняется максимально ((last1 - first1) + (last2 - first2)) * 2 - 1 сравнений.Результат set_union не определён, если возникающий в результате диапазон перекрывается с любым из первоначальных диапазонов.
set_union устойчив, то есть, если элемент присутствует в обоих диапазонах, он копируется из первого диапазона.

template <class InputIterator1, class InputIterator2, 
    class OutputIterator>
OutputIterator set_intersection(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator result);

template <class InputIterator1, class InputIterator2, 
    class OutputIterator, class Compare>
OutputIterator set_intersection(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator result, 
    Compare comp);
set_intersection создаёт сортированное пересечение элементов из двух диапазонов. Он возвращает конец созданного диапазона. Гарантируется, что set_intersection устойчив, то есть, если элемент присутствует в обоих диапазонах, он копируется из первого диапазона. Выполняется максимально ((last1 - first1) + (last2 - first2)) * 2 - 1 сравнений. Результат set_union не определён, если возникающий в результате диапазон перекрывается с любым из первоначальных диапазонов.

template <class InputIterator1, class InputIterator2, 
    class OutputIterator>
OutputIterator set_difference(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator  result);

template <class InputIterator1, class InputIterator2, 
    class OutputIterator, class Compare>
OutputIterator set_difference(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator result, 
    Compare comp);
set_difference создаёт сортированную разность элементов из двух диапазонов. Он возвращает конец созданного диапазона. Выполняется максимально ((last1 - first1) + (last2 - first2)) * 2 - 1 сравнений. Результат set_difference не определён, если возникающий в результате диапазон перекрывается с любым из первоначальных диапазонов.

template <class InputIterator1, class InputIterator2, 
    class OutputIterator>
OutputIterator set_symmetric_difference(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator result);

template <class InputIterator1, class InputIterator2, 
    class OutputIterator, class Compare>
OutputIterator set_symmetric_difference(InputIterator1 first1, 
    InputIterator1 last1, InputIterator2 first2, 
    InputIterator2 last2, OutputIterator result, 
    Compare comp);
set_symmetric_difference создаёт сортированную симметричную разность элементов из двух диапазонов. Он возвращает конец созданного диапазона. Выполняется максимально ((last1 - first1) + (last2 - first2)) * 2 - 1 сравнений. Результат set_symmetric_difference не определён, если возникающий в результате диапазон перекрывается с любым из первоначальных диапазонов.
}
{Операции над пирамидами (Heap operations)

Пирамида - специфическая организация элементов в диапазоне между двумя итераторами произвольного доступа [a, b). Два её ключевые свойства: (1) *a - самый большой элемент в диапазоне, (2) *a может быть удалён с помощью pop_heap или новый элемент добавлен с помощью push_heap за O(logN) время. Эти свойства делают пирамиды полезными для приоритетных очередей. make_heap преобразовывает диапазон в пирамиду, a sort_heap превращает пирамиду в сортированную последовательность.

template <class RandomAccessIterator>
void push_heap(RandomAccessIterator first, 
    RandomAccessIterator last);

template <class RandomAccessIterator, class Compare>
void push_heap(RandomAccessIterator first, 
    RandomAccessIterator last, Compare comp);
push_heap полагает, что диапазон [first, last - 1) является соответствующей пирамидой, и надлежащим образом помещает значение с позиции last - 1 в результирующую пирамиду [first, last). Выполняется максимально log(last - first) сравнений.

template <class RandomAccessIterator> 
void pop_heap(RandomAccessIterator first, 
    RandomAccessIterator last);

template <class RandomAccessIterator, class Compare>
void pop_heap(RandomAccessIterator first, 
    RandomAccessIterator last, 
    Compare comp);
pop_heap полагает, что диапазон [first, last) является соответствующей пирамидой, затем обменивает значения в позициях first и last - 1 и превращает [first, last - 1) в пирамиду. Выполняется максимально 2 * log(last - first) сравнений.

template <class RandomAccessIterator>
void make_heap(RandomAccessIterator first, 
    RandomAccessIterator last);

template <class RandomAccessIterator, class Compare>
void make_heap(RandomAccessIterator first, 
    RandomAccessIterator last, 
    Compare comp);
make_heap создает пирамиду из диапазона [first, last). Выполняется максимально 3 * (last - first) сравнений.

template <class RandomAccessIterator> 
void sort_heap(RandomAccessIterator first, 
    RandomAccessIterator last);

template <class RandomAccessIterator, class Compare>
void sort_heap(RandomAccessIterator first, 
    RandomAccessIterator last, Compare comp);
sort_heap сортирует элементы в пирамиде [first, last). Выполняется максимально NlogN сравнений, где N равно last - first. sort_heap не устойчив.
}
{Минимум и максимум (Minimum and maximum)

template <class T> 
const T& min(const T& a, const T& b);

template <class T, class Compare> 
const T& min(const T& a, const T& b, Compare comp);

template <class T> 
const T& max(const T& a, const T& b);

template <class T, class Compare> 
const T& max(const T& a, const T& b, Compare comp);
min возвращает меньшее, а max большее. min и max возвращают первый параметр, когда их параметры равны.

template <class ForwardIterator> 
ForwardIterator max_element(ForwardIterator first, 
    ForwardIterator last);

template <class ForwardIterator, class Compare>
ForwardIterator max_element(ForwardIterator first, 
    ForwardIterator last, Compare comp);
max_element возвращает первый такой итератор i в диапазоне [first, last), что для любого итератора j в диапазоне [first, last) выполняются следующие соответствующие условия: !(*i < *j) или comp(*i, *j) == false. Выполняется точно max((last - first) - 1, 0) соответствующих сравнений.

template <class ForwardIterator> 
ForwardIterator min_element(ForwardIterator first, 
    ForwardIterator last);

template <class ForwardIterator, class Compare>
ForwardIterator min_element(ForwardIterator first, 
    ForwardIterator last, Compare comp);
min_element возвращает первый такой итератор i в диапазоне [first, last), что для любого итератора j в диапазоне [first, last) выполняются следующие соответствующие условия: !(*j < *i) или comp(*j, *i) == false. Выполняется точно max((last - first) - 1, 0) соответствующих сравнений.
}
{Лексикографическое сравнение (Lexicographical comparison)

template <class InputIterator1, class InputIterator2>
bool lexicographical_compare(InputIterator1 first1, InputIterator1 last1,
     InputIterator2 first2, InputIterator2 last2);

template <class InputIterator1, class InputIterator2, class Compare> 
bool lexicographical_compare(InputIterator1 first1, InputIterator1 last1,
    InputIterator2 first2, InputIterator2 last2, Compare comp);
lexicographical_compare возвращает true, если последовательность элементов, определённых диапазоном [first1, last1), лексикографически меньше, чем последовательность элементов, определённых диапазоном [first2, last2). Иначе он возвращает ложь. Выполняется максимально 2 * min((last1 - first1), (last2 - first2)) сравнений.
}
{Генераторы перестановок (Permutation generators)

template <class BidirectionalIterator> 
bool next_permutation(BidirectionalIterator first, 
    BidirectionalIterator last);

template <class BidirectionalIterator, class Compare>
bool next_permutation(BidirectionalIterator first, 
    BidirectionalIterator last, Compare comp);
next_permutation берёт последовательность, определённую диапазоном [first, last), и трансформирует её в следующую перестановку. Следующая перестановка находится, полагая, что множество всех перестановок лексикографически сортировано относительно operator< или comp. Если такая перестановка существует, возвращается true. Иначе он трансформирует последовательность в самую маленькую перестановку, то есть сортированную по возрастанию, и возвращает false. Максимально выполняется (last - first)/2 перестановок.

template <class BidirectionalIterator>
bool prev_permutation(BidirectionalIterator first, 
    BidirectionalIterator last);

template <class BidirectionalIterator, class Compare>
bool prev_permutation(BidirectionalIterator first, 
    BidirectionalIterator last, Compare comp);
prev_permutation берёт последовательность, определённую диапазоном [first, last), и трансформирует её в предыдущую перестановку. Предыдущая перестановка находится, полагая, что множество всех перестановок лексикографически сортировано относительно operator< или comp. Если такая перестановка существует, возвращается true. Иначе он трансформирует последовательность в самую большую перестановку, то есть сортированную по убыванию, и возвращает false. Максимально выполняется (last - first)/2 перестановок.
}
}
{Обобщённые численные операции (Generalized numeric operations)
{Накопление (Accumulate)

template <class InputIterator, class T>
T accumulate(InputIterator first, InputIterator last, T init);

template <class InputIterator, class T, class BinaryOperation>
T accumulate(InputIterator first, InputIterator last, T init, 
    BinaryOperation binary_op);
accumulate подобен оператору APL reduction и функции Common Lisp reduce, но он избегает трудности определения результата уменьшения для пустой последовательности, всегда требуя начальное значение. Накопление выполняется инициализацией сумматора acc начальным значением init и последующим изменением его acc = acc + *i или acc = binary_op(acc, *i) для каждого итератора i в диапазоне [first, last) по порядку. Предполагается, что binary_op не вызывает побочных эффектов.
}
{Скалярное произведение (Inner product)

template <class InputIterator1, class InputIterator2, class T> 
T inner_product(InputIterator1 first1, InputIterator1 last1, 
    InputIterator2 first2, T init);

template <class InputIterator1, class InputIterator2, class T,
    class BinaryOperation1, class BinaryOperation2> 
T inner_product(InputIterator1 first1, InputIterator1 last1,
    InputIterator2 first2, T init,
    BinaryOperation1 binary_op1, BinaryOperation2 binary_op2);
inner_product вычисляет свой результат, инициализируя сумматор acc начальным значением init и затем изменяя его acc = acc + (*i1) * (*i2) или acc = binary_op1 (acc, binary_op2 (*i1, *i2)) для каждого итератора i1 в диапазоне [first, last) и итератора i2 в диапазоне [first2, first2 + (last - first)) по порядку. Предполагается, что binary_op1 и binary_op2 не вызывают побочных эффектов.
}
{Частичная сумма (Partial sum)

template <class InputIterator, class OutputIterator>
OutputIterator partial_sum(InputIterator first, InputIterator last, 
    OutputIterator result);

template <class InputIterator, class OutputIterator, class BinaryOperation> 
OutputIterator partial_sum(InputIterator first, InputIterator last, 
    OutputIterator result, BinaryOperation binary_op);
partial_sum присваивает каждому итератору i в диапазоне [result, result + (last - first)) значение, соответственно равное ((...(*first + *(first + 1)) + ...) + *(first + (i - result))) или binary_op(binary_op(..., binary_op(*first, *(first + 1)), ...), *(first + (i - result))). Функция partial_sum возвращает result + (last - first). Выполняется binary_op точно (last - first) - 1 раз. Ожидается, что binary_op не имеет каких-либо побочных эффектов. result может быть равен first.
}
{Смежная разность (Adjacent difference)

template <class InputIterator, class OutputIterator>
OutputIterator adjacent_difference(InputIterator first, InputIterator last, 
    OutputIterator result); 

template <class InputIterator, class OutputIterator, class BinaryOperation> 
OutputIterator adjacent_difference(InputIterator first, InputIterator last, 
    OutputIterator result, BinaryOperation binary_op);
adjacent_difference присваивает каждому элементу, указываемому итератором i в диапазоне [result + 1, result + (last - first)) значение, соответственно равное *(first + (i - result)) - *(first + (i - result) - 1) или binary_op(*(first + (i - result)), *(first + (i - result) - 1)). Элемент, указываемый result, получает значение *first. Функция adjacent_difference возвращает result + (last - first). Применяется binary_op точно (last - first) - 1 раз. Ожидается, что binary_op не имеет каких-либо побочных эффектов. result может быть равен first.
}
}
