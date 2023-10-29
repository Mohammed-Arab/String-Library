;Name:		Mohammed Arab
;Email:		marab065@mtroyal.ca
;course:	comp2655
;Assignment:	5
;Due date:	Dec 7,22
;Instructor:	Paul
;File:		main.s
;Purpose:	A string library consisting of 7 subroutines
;Details:
;		the program makes a string library that consists of 
;		7 subroutines. StrLen which returns the actual size used of the string
;		StrMaax returns the max size of the string.
;		StrCOncat appends the source string into destination string.
;		SubStr extracts a substring from the source and placing
;		it in the destination string.
;		StrScan checks for the occurence of a target in the source string.
;		StrCmp makes a lexicographical coparision of two strings.
;		StrPrint prints the actual size of string else prints out nothing. 


;----------Register table----------	
;	d0:
;		-output stores the ascii value of char
;		-used as a decrement counter at StrCmp
;		-stores the character of the first string in StrCmp
;	a0:
;		-stores the first param in all functions
;		-stores string to be printed
;	d1:
;		-stores string1 actual length in all functions
;		-stores char of second string in StrCmp
;	a1:
;		-stores seocnd paramter in all functions
;	d2:	
;		-stores string2 actual length in all functions
;	a2:
;		-stores the address of ERROR in StrConCat
;	d3:
;		-stores sum of string1 and string2 actual length
;	d4:
;		-stores max length of string1 in StrConCat
;		-stores index increment of target in StrScan
;	d5:
;		-stores actual length of target in StrScan and used for dbra
;	d6:
;		-stroes the index of occurrence in StrScan
;----------------------------------------------------------------------------
	xdef	StrLen
	xdef	StrMax
	xdef	StrConcat
	xdef	SubStr
	xdef	StrScan
	xdef	StrCmp
	xdef	StrPrint
;-------equ----------
CR	equ	13
LF	equ	10
PARAM1	equ	8
PARAM2	equ	12
RTRN1	equ	12
RTRN2	equ	16

;-----SUBROUTINE: StrLen-------
;int StrLen(char[] string)
;returns actual length of String
;status working passes all tests

StrLen:	
	link	a6,#0
	movem.l	a0,-(sp)	;saving what is in a4 before the call
	move.l	PARAM1(a6),a0		
	move.b	-1(a0),RTRN1(a6);returning actual length
	movem.l	(sp)+,a0	;returning the value of a4 back before leaving 
	unlk	a6
	rts

;-----SUBROUTINE: StrMax-------
;int StrMax(char[] string)
;returns max length of string
;status working passes all tests

StrMax:		
	link	a6,#0
	movem.l	a0,-(sp)
	move.l	PARAM1(a6),a0
	move.b	-2(a0),RTRN1(a6);returning max length
	movem.l	(sp)+,a0
	unlk	a6
	rts

;------SUBROUTINE: StrConcat----------
;void StrConcat(char[] destination, char[] source, bool error)
;adds string2 (source) to the end of string1 (destination)
;if string1 has insufficient space then ERROR will return (-1) TRUE
;else operation should be performed and ERROR returns (0) FALSE
;status working passes all tests

StrConcat:
	link	a6,#0
	movem.l	d1-d4/a0-a2,-(sp)
	clr.l	d1
	clr.l	d2
	clr.l	d3
	clr.l	d4
	move.l	RTRN2(a6),a2	;holds return address
	move.l	PARAM1(a6),a0	;loading destination
	move.b	-1(a0),d1	;stores actual length of string1(destination)	
	move.b	-2(a0),d4	;''      max   ''    ''  ''      ''
	move.l	PARAM2(a6),a1	;loading source
	move.b	-1(a1),d2	;stores actual length of string2(source)
	cmp.b	d4,d2
	bhi	no_change
	move.b	d2,d3
	add.b	d1,d3
	cmp.b	d4,d3
	bhi	no_change
	move.b	d3,-1(a0)	;change actual size of destination
	
make_change:
	move.b	(a1)+,(a0)+
	dbra	d2,make_change
	move.b	#0,(a2)
	bra	changed

no_change:
	move.b	#-1,(a2)	

changed:
	movem.l	(sp)+,d1-d4/a0-a2
	unlk	a6
	rts

;------SUBROUTINE: SubStr----------
;void SubStr(char[] destination, int start, int length, char[] source, error)
;extracts substring from source string beginning at start and consisting of length
;placing the substring in the destination string, size of length
;if(length > max length of destination)return -1
;if(start >=length && length != 0)return -1
;if(length > actual length source)return -1
;else substring performed and return 0
;status not fully working 
;fails to copy the substring
SubStr:
	link	a6,#0
	movem.l	d0-d7/a0-a2,-(sp)
	clr.l	d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
	clr.l	d4
	clr.l	d5
	clr.l	d6
	clr.l	d7
	move.l	20(a6),a2
	move.l	PARAM1(a6),a0		;loading string1
	move.b	-2(a0),d4		;loads string1 max length(destinaton)
	move.l	16(a6),a1		;loading string2 source
	move.b	-1(a1),d2		;string2 actual
	move.b	12(a6),d5		;start index
	move.b	14(a6),d6		;length
	cmp.b	d4,d6
	bhi	TRUE
	tst.b	d6
	subq.b	#1,d2
	beq	check_index
	cmp.b	d2,d5
	bhs	TRUE
	move.b	d5,d7
	move.b	d2,d3
	sub.b	d5,d3
	subq.b	#1,d3
	subq.b	#1,d7
	adda.l	d7,a1
	move.b	d6,-1(a0)
	cmp.b	d3,d6
	bhi	dbra_actual
dbra_length:
	move.b	(a1)+,(a0)+
	dbra	d6,dbra_length
	bra	False
	
dbra_actual:
	move.b	(a1)+,(a0)+
	dbra	d3,dbra_actual
	bra	False

check_index:
	tst.b	d5	
	bne	TRUE
False:
	move.w	#0,(a2)
	bra	substr_done	
	
TRUE:
	move.w	#-1,(a2)

substr_done:
	movem.l	(sp)+,d0-d7/a0-a2
	unlk	a6
	rts

;------SUBROUTINE: StrScan---------
;int StrScan(char[] source, char[] target)
;returns the index of the first char of (target)
;if (target) has anoccurence in (source) 
;returns 0 if target actual length is 0
;else retrun -1 if target is not found in source
;status working passes all tests

StrScan:
	link	a6,#0
	movem.l	d0-d6/a0-a1,-(sp)
	clr.l	d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
	clr.l	d4
	clr.l	d5
	clr.l	d6
	move.l	PARAM1(a6),a0	;loading string1
	move.b	-1(a0),d1	;loads string1 actual length(source)
	move.l	PARAM2(a6),a1	;loading string2
	move.b	-1(a1),d2	;loads string2 actual length(target)
	tst.b	d2
	beq	found_index
	cmp.b	d1,d2
	bhi	not_found
	move.b	d2,d5
	move.b	d1,d0		;decrement loop counter
	subq.b	#1,d0
	subq.b	#1,d5
	
compare_target:
	cmp.b	(a0)+,(a1)+
	bne	add_one
	subq.b	#1,d5

next_index:	
	addq.b	#1,d4
	cmp.b	(a0)+,(a1)+	
	bne	target_0	
	dbra	d5,next_index
	bra 	found_index	

add_one:
	suba.l	#1,a1
	addq.b	#1,d3
	move.b	d3,d6		;holds curr index
	dbra	d0,compare_target
	bra	not_found

target_0:
	add.b	d4,d3
	addq.b	#1,d4
	suba.l	d4,a1
	suba.l	#1,a0
	clr.l	d4
	clr.l	d5
	move.b	d2,d5
	subq.b	#1,d5
	dbra	d0,compare_target
	bra 	not_found

found_index:
	move.w	d6,RTRN2(a6)
	bra	strscan_done

not_found:
	move.w	#-1,RTRN2(a6)

strscan_done:
	movem.l	(sp)+,d0-d6/a0-a1
	unlk	a6	
	rts 

;------SUBROUTINE: StrCmp----------
;int StrCmp(char[] string1, char[] string2)
;does a lexciofraphical comparison of string1 to string2
;if (string 1 is < string2)retrun-1
;else if(string1==string2)return0
;else (return1)
;status working passes all tests

StrCmp:		
	link	a6,#0
	movem.l	d0-d2/a0-a1,-(sp)
	clr.l	d0
	clr.l	d1
	clr.l	d2
	move.l	PARAM1(a6),a0	;loading string1
	move.b	-1(a0),d1	;loads string1 actual length
	move.l	PARAM2(a6),a1	;loading string2
	move.b	-1(a1),d2	;loads string2 actual length
	tst.b	d1
	beq	check_string2
	tst.b	d2
	beq	S2_less
	cmp.b	d1,d2		;checking for the smallest string actual length to compare
	bhi	String2_longer
	subq.b	#1,d1
	subq.b	#1,d2
	move.b	d2,d0
	bra	check

check_string2:
	tst.b	d2
	beq	move_zero
	bra	S2_greater

String2_longer:
	subq.b	#1,d1
	subq.b	#1,d2
	move.b	d1,d0		

check:
	cmp.b	(a0)+,(a1)+	;checks every char in both strings
	bne	less_or_greater	;branches if one char is not the same
	dbra	d0,check	
	cmp.b	d1,d2		;checks for the strings actual length and compare which is less 
	bne	extra_char	;else string1==string2	

move_zero:
	move.w	#0,RTRN2(a6)
	bra	done

extra_char:
	cmp.b	d1,d2		;in case of same chars but string1 length is less than string2
	blo	S2_less		;branches if string2 length is less than string1 length					
	bra 	S2_greater

less_or_greater:
	clr.l	d0
	clr.l	d1
	move.b	-(a0),d0
	move.b	-(a1),d1
	cmp.b	d0,d1		;checks for same index but not same char
	bhi	S2_greater	
S2_less:
	move.w	#1,RTRN2(a6)
	bra	done

S2_greater:
	move.w	#-1,RTRN2(a6)

done:
	movem.l	(sp)+,d0-d2/a0-a1
	unlk	a6
	rts

;---------SUBROUTINE: StrPrint--------
;void StrPrint(char[] string), outputs string to the screen
;with no formatting, it is done using GEMDOS	
;status working passes all tests

StrPrint:
	link	a6,#0
	movem.l	d0-d1/a0,-(sp)
	clr.l	d0
	clr.l	d1
	move.l	PARAM1(a6),a0	;loads string 
	move.b	-1(a0),d1	;loads actual size to use for dbra
	tst.b	d1
	beq	end_print	;if(actual==0)return
	subq.b	#1,d1
Print:	
	move.b	(a0)+,d0
	jsr	write_char
	dbra	d1,Print

end_print:
	movem.l	(sp)+,d0-d1/a0
	unlk	a6	
	rts

;----- SUBROUTINE: write_cahr--------
; writes a single character to the screen
; takes the ASCII value of the character in the low byte
; of register 

write_char:	
	link	a6,#0
	movem.l	d0-d2/a0-a2,-(sp)
	and.w	#$00FF,d0
	move.w	d0,-(sp)
	move.w	#2,-(sp)
	trap	#1
	addq.l	#4,sp
	move.l	d0,RTRN1(a6)
	movem.l	(sp)+,d0-d2/a0-a2
	unlk	a6
	rts