        .ORIG       x3300
        .FILL	    x4000    ; x3300    Pointer to 1st node in the linked-list
        .BLKW       x0cff
;
; The linked-list
; Starting address x4000
;
; 1st node
node1   .FILL       node2
        .FILL       num1
        .FILL       name1
;
; 2nd node
node2   .FILL       node3
        .FILL       num2
        .FILL       name2
;
; 3rd node
node3   .FILL       node4
        .FILL       num3
        .FILL       name3
;
; 4th node
node4   .FILL       x0000
        .FILL       num4
        .FILL       name4
;
; Names and office numbers
;
; data for 1st node
name1   .STRINGZ    "Chen"
num1    .STRINGZ    "509"
;
; data for 2nd node
name2   .STRINGZ    "jiang"
num2    .STRINGZ    "320"
;
; data for 3rd node
name3   .STRINGZ    "knuth"
num3    .STRINGZ    "121A"
;
; data for 4th node
name4   .STRINGZ    "turing"
num4    .STRINGZ    "410B"
;
	.END