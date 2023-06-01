;
;Ellie Leutenegger ECE109 001 03/24/2023
;This program changes a counter value based on user input.
;If the following are commands typed by the user that control the counter:
;'u' increments, 'd' decrements, 'r' resets to 0000, 'p' prints the current value,
;and 'q' quits the simulator. All other characters have no effect.
;

	.ORIG x3000 
	
		;clear registers
START		AND R0, R0, #0	
			AND R1, R1, #0
			AND R2, R2, #0
			AND R3, R3, #0
			AND R4, R4, #0
			AND R5, R5, #0
			AND R6, R6, #0
		
		;print digits 0000 to the display
RESET		LD R5, POS48		;load R5 with ASCII zero so it knows what number to print
			ST R5, 1PLACE		;store a place in memory with ASCII zero for one's
			ST R5, 2PLACE
			ST R5, 3PLACE
			ST R5, 4PLACE
			BR DIGIT	
		
		;print digits 9999 to the display	
OPPSET		LD R5, POS9			;opposite of reset
			ST R5, 1PLACE		;store a place in memory with ASCII zero for one's
			ST R5, 2PLACE
			ST R5, 3PLACE
			ST R5, 4PLACE
			BR DIGIT	

		;load the coordinates for each place into R1 and send to print
DIGIT		LD R1, THOUPL		;load R1 with the coordinate for each place
			JSR PRINT			;go to sub routine for print
			LD R1, HUNPL
			JSR PRINT
			LD R1, TENPL
			JSR PRINT
			LD R1, ONEPL
			JSR PRINT

		;wait for user to type command character (do not echo)
COMMAND		GETC
				
		;Check if u
			LD R1, u			;Load the ASCII value for the letter u
    		NOT R1, R1		  	;2sC of u
    		ADD R1, R1, #1		;
    		ADD R1, R1, R0		;Add the negated number to input
  			BRz INCREM      	;Branch to INCREM if the result is zero
  			
		;Check if d
			LD R1, d			;Load the ASCII value for the letter d
    		NOT R1, R1		  	;2sC of d
    		ADD R1, R1, #1		;
    		ADD R1, R1, R0		;Add the negated number to input
  			BRz DECREM      	;Branch to DECREM if the result is zero
  			
		;Check if r
			LD R1, r			;Load the ASCII value for the letter r
    		NOT R1, R1		  	;2sC of r
    		ADD R1, R1, #1		;
    		ADD R1, R1, R0		;Add the negated number to input
  			BRz RESET	    	;Branch to RESET if the result is zero
  			
		;Check if p
			LD R1, p			;Load the ASCII value for the letter p
    		NOT R1, R1		  	;2sC of p
    		ADD R1, R1, #1		;
    		ADD R1, R1, R0		;Add the negated number to input
  			BRz CURRVAL      	;Branch to CURRVAL if the result is zero
  			
		;Check if q
			LD R1, q			;Load the ASCII value for the letter q
    		NOT R1, R1		  	;2sC of q
    		ADD R1, R1, #1		;
    		ADD R1, R1, R0		;Add the negated number to input
  			BRz QUIT	      	;Branch to QUIT if the result is zero
  			
  			BR COMMAND			;other characters are ignored
  			
  		;for incrementing the counter
INCREM		LD R5, 1PLACE		;increments the ones place
			ADD R5, R5, #1		;adds 1 to the register with the number it prints
			LD R3, NEGA9		;if its 9 and u is clicked again, go change tens place
			ADD R3, R5, R3
			BRz GOTEN
			LD R1, ONEPL		;load R1 with coordinates for ones place
			JSR PRINT			;print
			ST R5, 1PLACE		
			BR COMMAND

	GOTEN		LD R5, POS48
				LD R1, ONEPL
				ST R5, 1PLACE
				JSR PRINT		
				LD R5 2PLACE
				ADD R5, R5, #1
				LD R3, NEGA9
				ADD R3, R5, R3
				BRz GOHUN
				LD R1, TENPL
				JSR PRINT
				ST R5, 2PLACE	
				BR COMMAND
				
		GOHUN		LD R5, POS48
					LD R1, TENPL
					ST R5, 2PLACE
					JSR PRINT		
					LD R5 3PLACE
					ADD R5, R5, #1
					LD R3, NEGA9
					ADD R3, R5, R3
					BRz GOTHOU
					LD R1, HUNPL
					JSR PRINT
					ST R5, 3PLACE	
					BR COMMAND
			
			GOTHOU		LD R5, POS48
						LD R1, HUNPL
						ST R5, 3PLACE
						JSR PRINT		
						LD R5 4PLACE
						ADD R5, R5, #1
						LD R3, NEGA9
						ADD R3, R5, R3
						BRz RESET			;when it hits 9999, go back to 0000 (reset)
						LD R1, THOUPL
						JSR PRINT
						ST R5, 4PLACE	
						BR COMMAND				

		;for decrementing the counter
DECREM		LD R5, 1PLACE		;decrements the ones place
			ADD R5, R5, #-1		;subtracts 1 to the register with the number it prints
			LD R3, NEGA0		;if its 0 and d is clicked again, go change tens place
			ADD R3, R5, R3
			BRz DOWNTEN
			LD R1, ONEPL
			JSR PRINT
			ST R5, 1PLACE
			BR COMMAND
			
	DOWNTEN		LD R5, POS9
				LD R1, ONEPL
				ST R5, 1PLACE
				JSR PRINT		
				LD R5, 2PLACE
				ADD R5, R5, #-1
				LD R3, NEGA0
				ADD R3, R5, R3
				BRz DOWNHUN
				LD R1, TENPL
				JSR PRINT
				ST R5, 2PLACE	
				BR COMMAND
				
		DOWNHUN		LD R5, POS9
					LD R1, TENPL
					ST R5, 2PLACE
					JSR PRINT		
					LD R5, 3PLACE
					ADD R5, R5, #-1
					LD R3, NEGA0
					ADD R3, R5, R3
					BRz DOWNTHOU
					LD R1, HUNPL
					JSR PRINT
					ST R5, 3PLACE	
					BR COMMAND
					
			DOWNTHOU	LD R5, POS9
						LD R1, HUNPL
						ST R5, 3PLACE
						JSR PRINT		
						LD R5, 4PLACE
						ADD R5, R5, #-1
						LD R3, NEGA0
						ADD R3, R5, R3
						BRz OPPSET			;when it hits 0000, go back to 9999 (oppset)
						LD R1, THOUPL
						JSR PRINT
						ST R5, 4PLACE	
						BR COMMAND	

CURRVAL		LEA R0, PROMPTP
			PUTS
			LD R0, 4PLACE
			OUT
			LD R0, 3PLACE
			OUT
			LD R0, 2PLACE
			OUT
			LD R0, 1PLACE
			OUT
			BR COMMAND
			
QUIT		LEA R0, PROMPTQ		;load R0 with address of quit string
			PUTS				;print to console
			HALT
			
PROMPTQ		.STRINGZ 	"\n\nLater Yall!!\n"
PROMPTP		.STRINGZ 	"\nThe current value is: "
	
	;coordinates
THOUPL	.FILL 	xD508
HUNPL	.FILL	xD523
TENPL	.FILL	xD544
ONEPL	.FILL	xD55F
		
	;digits
DIG0	.FILL	x5000
DIG1	.FILL	x53E8
DIG2	.FILL	x57D0
DIG3	.FILL	x5BB8
DIG4	.FILL	x5FA0
DIG5	.FILL	x6388
DIG6	.FILL	x6770
DIG7	.FILL	x6B58
DIG8	.FILL	x6F40
DIG9	.FILL	x7328
DIGA	.FILL	xC080

	;colors
white	.FILL	x7FFF
black	.FILL 	x0000			

	;how to keep them stored
1PLACE	.FILL	#0048
2PLACE	.FILL	#0048
3PLACE	.FILL	#0048
4PLACE	.FILL	#0048

	;commands
u		.FILL	x75
d		.FILL	x64
r		.FILL	x72
p		.FILL	x70
q		.FILL	x71

	;random numbers
NEG0	.FILL	#-48
POS48	.FILL	#48
POS9	.FILL	#57
NEGA0	.FILL	#-47
NEGA9	.FILL	#-58

	;printing subroutine thing
PRINT		ST R0, SAVER0
			ST R1, SAVER1
			ST R2, SAVER3
			ST R3, SAVER3
			ST R4, SAVER4
			ST R5, SAVER5
			ST R6, SAVER6
			ST R7, SAVER7
			
			LD R4, NEG0
				ADD R4, R5, R4
				LEA R6, DIG0
				ADD R4, R6, R4
				LDR R5, R4, #0
				
				LD R6, COLUMN		;this be for the columns
	LOOP1		LD R3, ROW			;and this be for the rows
		
	LINE		LDR R2, R5, #0		;keep R5 in its location but load it to R2 to work w
				AND R4, R4, #0		;clear R4
				AND R4, R2, #1		;add 1 to R2 (technically R5) and put in R4
				BRp WHITEPR			;if that number is positive, print a white pixel
				
	BLACKPR		AND R0, R0, #0		;clear R0
				STR R0, R1, #0		;store black
				BR NEXT				;print black
							
	WHITEPR		LD R0, white		;load R0 to print white			
				STR R0, R1, #0		;paint white
			
	NEXT		ADD R1, R1, #1
				ADD R5, R5, #1
				ADD R3, R3, #-1		;only execute 25 times
				BRp LINE			;if positive, keep going back to line
				
				ADD R1, R1, #15		;103 to go to next row
				ADD R1, R1, #15
				ADD R1, R1, #15
				ADD R1, R1, #15
				ADD R1, R1, #15
				ADD R1, R1, #15
				ADD R1, R1, #13
				ADD R6, R6, #-1 	;only execute 40 times
				BRp LOOP1			;if positive, keep looping
				
				LD R0, SAVER0
				LD R1, SAVER1
				LD R2, SAVER2
				LD R3, SAVER3
				LD R4, SAVER4
				LD R5, SAVER5
				LD R6, SAVER6
				LD R7, SAVER7
				RET					;returns back to calling routine
				
		;memory for JSR
SAVER0	.FILL	x00
SAVER1	.FILL	x00
SAVER2	.FILL	x00
SAVER3	.FILL	x00
SAVER4	.FILL	x00
SAVER5	.FILL	x00
SAVER6	.FILL	x00
SAVER7	.FILL	x00
COLUMN	.FILL	#40				
ROW		.FILL	#25	
	
.END