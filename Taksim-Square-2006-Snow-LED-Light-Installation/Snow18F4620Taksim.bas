' Zerolight Taksim Square LED Installation December 2006
' Lead Developer: Burçkaan Gürgün
' System Architecture: Developed for the PIC18F4620 microcontroller to orchestrate the LED infrastructure at Taksim Square.
' Technical Specifications:
'    •    Master Control: The system operates as a DMX Transmitter (Master), utilizing a custom-engineered RS-485 protocol for high-reliability communication.
'    •    Receiving Architecture: Interfaced with hundreds of decentralized DMX Receivers based on the PIC16F648 (running custom firmware).
'    •    Distributed Control: Each PIC16F648 receiver manages 8 individual single-color LED channels at unique addresses.
'    •    Orchestration: A single PIC18F4620 serves as the primary system orchestrator, managing the synchronized data flow across the vast network of hundreds of addressed nodes.


	Device = 18F4620								' Choose a device with on-board full speed USB
	Declare ONBOARD_USB FALSE
    Declare XTAL = 40										' Set the oscillator speed to 48MHz (using a 20MHz crystal)
'    @CONFIG_REQ 
'    @__CONFIG    config1l, PLLDIV_5_1 & CPUDIV_1_1 & USBDIV_2_1
'    @__CONFIG    config1h, FOSC_HSPLL_HS_1 & FCMEM_OFF_1 & IESO_OFF_1 
'    @__CONFIG    config2l, PWRT_OFF_2 & BOR_ON_2 & BORV_27_2 & VREGEN_ON_2
'    @__CONFIG    config2h, WDT_OFF_2 & WDTPS_32768_2
'    @__CONFIG    config3h, MCLRE_ON_3 & LPT1OSC_OFF_3 & PBADEN_OFF_3 & CCP2MX_ON_3
'    @__CONFIG    config4l, STVREN_ON_4 & LVP_OFF_4 & ICPRT_OFF_4 & XINST_OFF_4 & DEBUG_OFF_4

    
    Declare LCD_DTPIN = PORTD.4								' LCD data port attached to PORTD
	Declare LCD_RSPIN = PORTC.0								' LCD RS pin attached to PORTE.0
	Declare LCD_ENPIN = PORTC.1								' LCD EN pin attached to PORTE.1
	Declare LCD_INTERFACE = 4								' 4-bit Interface
	Declare LCD_LINES = 2									' 2 line LCD
	Declare LCD_TYPE = ALPHANUMERIC							' Use an Hitachi alphanumeric LCD								
    Declare WARNINGS = On     
    
    Declare ADIN_RES 8        ' 8-bit result required 
    Declare ADIN_TAD 32_FOSC  ' RC OSC chosen 
    Declare ADIN_STIME 100    ' Allow 100us sample time 
    Declare HBUS_BITRATE 1000
    

    Dim x               As Byte
    Dim y               As Byte
    Dim z               As Byte
    Dim kk              As Byte
    Dim break1          As Byte
    Dim MAB2            As Byte   
    Dim sendme          As Byte
    Dim rndByte1        As Byte
    Dim rndByte2        As Byte
    Dim doItMan         As Byte
    Dim cnt             As Byte
    Dim ad1             As Byte
    Dim ad2             As Byte
    Dim ad3             As Byte
    Dim ad4             As Byte
    Dim ad5             As Byte
    Dim ad6             As Byte
    Dim ad7             As Byte
    Dim ad8             As Byte
    Dim ad8i            As Byte
    Dim ad9i            As Byte
    Dim adc8            As Byte
    Dim adCnt           As Byte
    Dim ad8w            As Byte
    Dim reveR           As Byte
    Dim reveG           As Byte
    Dim reveB           As Byte
    Dim reve1R          As Byte
    Dim reve1G          As Byte
    Dim reve1B          As Byte
    Dim hm0             As Byte
    Dim maxB            As Byte
    Dim rnd1            As Word
    Dim rnd2            As Word
    Dim rnd3            As Word
    Dim rnd4            As Word
    Dim mav             As Byte
    Dim tri1            As Byte
    Dim tri2            As Byte
    Dim tri3            As DWord
    Dim art             As Byte
    Dim place1          As Byte
    Dim place2          As Byte
    Dim AddRed1[2]      As Word
    Dim bas             As Byte
    Dim son             As Byte
    Dim firstEprom      As Byte
    Dim aam             As Byte
    Dim Address         As Word         ' 16-bit address required
    Dim rem1            As Byte
    Dim rem1x           As Byte
    Dim devNum          As Byte
    Dim divMan          As Byte
    Dim x1              As Byte
    Dim r1a             As Byte
    Dim g1a             As Byte
    Dim b1a             As Byte
    Dim tmp             As Byte
    Dim tmp1            As Byte
    Dim tmp2            As Byte
    Dim tmp3            As Byte
    Dim tmp4            As Byte
    Dim tmp3w           As DWord
    Dim mavMax          As Byte
    Dim mavPos          As Byte
    Dim maxProg         As Byte
    Dim Posx            As Byte
    Dim siliyom         As Byte
    Dim remmi           As Byte
    Dim remmi1          As Byte


    Dim reve1Rz         As Byte
    Dim reve1Gz         As Byte
    Dim reve1Bz         As Byte
    Dim STRZ            As Byte
    Dim ENDZ            As Byte
    Dim PlsMnsZ         As Byte
    Dim GAP             As Byte
    Dim STRTGAP         As Byte
    Dim bckRz           As Byte
    Dim bckGz           As Byte
    Dim bckBz           As Byte
    Dim FrcBCK          As Byte
    Dim q1              As Byte
    Dim que1            As Byte
    Dim ker1            As Byte
    Dim ker2            As Byte
    Dim ker3            As Byte
    Dim ker             As Byte
    Dim ece1            As Byte
    Dim ece2            As Byte
    Dim ece3            As Byte
    Dim ct1             As Byte
    Dim ct2             As Byte
    Dim ct3             As Byte
    Dim ct4             As Byte
    Dim ct5             As Byte
    Dim moreR           As Byte
    Dim moreX           As Byte
    Dim moreT           As Byte
    Dim revdo           As Byte
    Dim capraz          As Byte
    Dim revrev1         As Byte
    Dim revrev2         As Byte
    Dim revrev3         As Byte
    Dim cnt1            As Word
    Dim cnt2            As Word
    Dim cnt3            As Word
    Dim cnt4            As Word



    Dim dmR[256]        As Byte
    Dim dmG[256]        As Byte
    Dim dmB[256]        As Byte
    Dim dmtR[256]       As Byte
    Dim dmtG[256]       As Byte
    Dim dmtB[256]       As Byte

    Dim r1[128]         As Byte
    Dim STRZa[128]      As Byte
    Dim ENDZa[128]      As Byte
    Dim space1[128]      As Byte
    Dim reve1Rza[128]   As Byte
    Dim PlsMnsZa[128]   As Byte
    Dim RGBif[128]      As Byte
    Dim SPD[129]        As Byte
    Dim SPDk[129]       As Byte
    
    
    
    Symbol Control %10100000        ' Target an eeprom
    
    
    TRISD = %00001110                   
    TRISB = %11111100
    TRISA = %00111111 
    TRISE = %00000111 
    TRISC = %10001100 

ADCON1 = %00000101	' Set PORTA analog and right justify result
ADCON2.7 = 0
'CMCON = 7

BAUDCON.3 = 0
SPBRG = 9'4 ' Set baud rate to 250000 
RCSTA = %00000000 ' Clear RCSTA to git rid of any errors 
TXSTA.0 = 1
TXSTA.2 = 1
TXSTA.4 = 0
TXSTA.5 = 0
TXSTA.6 = 1
High PORTC.6
    
'------------------------------------------------------------------------
' The main program loop starts here 
DelayMS 500											' Wait for things to stabilise
Clear												' Clear all RAM before we start 
Cls													' Clear the LCD

tmp1 = ERead 0
If tmp1 != 28 Then
    EWrite 0, [ 28 ]
    mav = 0
    EWrite 1, [ mav ]
Else
    mav = ERead 1
EndIf
GoSub mavAddr
hm0 = 3
'divMan = 255/devNum

    divMan = 1
    devNum = 255
    maxB = 250


Posx = 255

'    tmp = 256 / (maxB + 1)

    tmp = 1


DelayMS 100
Address = 1                   
HBusIn Control , Address,  [firstEprom]
DelayMS 100
Address = 1                   
HBusIn Control , Address,  [firstEprom]
Address = 2                   
HBusIn Control , Address,  [tmp1]
If firstEprom != 128 Then
    firstEprom = 128
    Address = 1                   
    HBusOut Control , Address,  [firstEprom]
    DelayMS 200
    firstEprom = 255
    Address = 2                   
    HBusOut Control , Address,  [firstEprom]
    DelayMS 200
EndIf
    
maxProg = 2
MAB2 = 14
break1 = 98
sendme = 0

mavPos = 255


reveR = 1
reveG = 1
reveB = 1
reve1R = 0
reve1G = 0
reve1B = 0


    
Cls
Print At 1,1,"Mod",Dec hm0


tri1 = 0
tri2 = 0
aam = 0
art = 0
rem1 = 32
cnt = 0
cnt1 = 0
cnt2 = 0
cnt4 = 40
revrev1 = 0
revrev2 = 0
revrev3 = 0

mainLoop:    
'noRUN
    GoSub rotator1
'RUN    GoSub rotator

'noRUN   
'RUN    ad1 = ADIn 0
    reveR = 1 + ad1/tmp 
    If reveR = 0 Then
        reveR = 255
    EndIf
    reveB = 1 + ad1/tmp                 
    If reveB = 0 Then
        reveB = 255
    EndIf
    reveG = 1 + ad1/tmp                  
    If reveG = 0 Then
        reveG = 255
    EndIf
'noRUN
'RUN    ad2 = ADIn 1
'noRUN
'RUN    ad3 = ADIn 2 
'noRUN
'RUN    ad4 = ADIn 3 
    reve1R = ad4/tmp                  
'noRUN
'RUN    ad5 = ADIn 4 
    reve1G = ad5/tmp                 
'noRUN
'RUN    ad6 = ADIn 5 
    reve1B = ad6/tmp
'noRUN
'RUN    ad7 = ADIn 7 
'noRUN
'RUN    ad8 = ADIn 6
    adc8 = 32 - ad8/8
    adc8 = 1 + adc8/divMan
    ad8w = 85-ad8/3

    If ad8w < 40 Then   
        If ad8w < 8 Then
            ad8w = 0-32
        Else
            ad8w  = ad8w - 39
        EndIf
    ElseIf ad8w > 45 Then
        If ad8w > 76 Then
            ad8w = 32
        Else
            ad8w = ad8w - 45
        EndIf
    Else
        ad8w = 0
    EndIf 
    SPD[128] = ad8
    doItMan = 0

'    C7,C2,D1
'RUNno
'noRUN    
    ad7 = 210
    If ad7 > 190 Then
        If Posx != 1 Then
            Posx = 1
            If PORTD.1 = 0 Then
                For x = 0 To devNum
                    dmtR[x] = 0
                    dmtG[x] = 0
                    dmtB[x] = 0
                Next x
            EndIf
            mavMax = 11
            If mav > mavMax Then
                mav = 0
                Cls
                Print At 1,1, "Mod",Dec hm0, " art:", DEC3 mav 
            EndIf
        EndIf
        Select mav
        Case 0
            GoSub DoPos1Mav0
        Case 1
            GoSub DoPos1Mav1
        Case 2
            GoSub DoPos1Mav2
        Case 3
            GoSub DoPos1Mav3
        Case 4
            GoSub DoPos1Mav4
        Case 5 
            GoSub DoPos1Mav5
        Case 6 
            GoSub DoPos1Mav6
        Case 7 
            GoSub DoPos1Mav7
        Case 8 
            GoSub DoPos1Mav8
        Case 9 
            GoSub DoPos1Mav9
        Case 10 
            GoSub DoPos1Mav10
        Case 11 
            GoSub DoPos1Mav11
        EndSelect   
    ElseIf ad7 > 60 Then
        If Posx != 2 Then
            Posx = 2
            mavMax = maxProg
            If mav > mavMax Then
                mav = 0
                Cls
                Print At 1,1, "Mod",Dec hm0, " art:", DEC3 mav 
            EndIf
            GoSub mavAddr
        EndIf
'burckaan dikkat
'        SPD[128] = ad6
        SPD[128] = 0
        GoSub progExe
    Else  
        SPD[128] = 0
        If PORTC.7 = 1 Then
            If Posx != 3 Then
                Posx = 3
                Address = 2
                HBusIn Control , Address,  [tmp1]
                que1 = 0
                mavMax = tmp1
                If mav > mavMax Then
                    mav = 0
                    Cls
                    Print At 1,1, "Mod",Dec hm0, " art:", DEC3 mav 
                EndIf
            EndIf
            If que1 = 0 Then
                reve1Rz = (maxB*ad1)/255
                reve1Gz = (maxB*ad1)/255
                reve1Bz = (maxB*ad1)/255
                GAP = (256 - ad8)/divMan
                STRZ = ad4/divMan
                ENDZ = ad5/divMan
                tmp2 = 1+ad6/8
                If STRZ < ENDZ Then 
                    PlsMnsZ = tmp2
                    ENDZ = (ENDZ - STRZ)/tmp2
                    ENDZ = STRZ + ENDZ * tmp2
                Else
                    PlsMnsZ = 256-tmp2
                    ENDZ = (STRZ -ENDZ)/tmp2
                    ENDZ = STRZ - ENDZ * tmp2
                EndIf
                
                
                
                Cls
                Address = 2
                HBusIn Control , Address,  [tmp1]
                Cls
                Print At 1,1, "R1: ", DEC3 reve1Rz, " ", DEC3 reve1Gz, " ", DEC3 reve1Bz
                Print At 2,1, "P1: ", DEC3 STRZ, " ", DEC3 ENDZ, " ", DEC3 PlsMnsZ, " ", DEC3 GAP
                
                For x = 0 To devNum
                    dmR[x] = 0
                    dmG[x] = 0
                    dmB[x] = 0
                Next x
                dmR[STRZ] = reve1Rz
                dmG[STRZ] = reve1Gz
                dmB[STRZ] = reve1Bz
                  
                dmR[ENDZ] = reve1Rz
                dmG[ENDZ] = reve1Gz
                dmB[ENDZ] = reve1Bz
                If PORTC.2 = 0 Then
                    siliyom = 1
                Else
                    siliyom = 0
                EndIf
                
                If PORTD.1 = 1 Then
                    que1 = 1
                    DelayMS 1500
                    If siliyom = 1 And PORTC.2 = 1 Then
                        que1 = 0
                        Address = 2
                        DelayMS 200
                        tmp1 = 255
                        HBusOut Control , Address,  [tmp1]
                        DelayMS 200
                        Cls
                        HBusIn Control , Address,  [tmp1]
                        Print At 1,1, "ALL DELETED ", Dec tmp1
                    EndIf    
                EndIf
                DelayMS 100
            Else
                bckRz = (maxB*ad1)/255
                bckGz = (maxB*ad1)/255
                bckBz = (maxB*ad1)/255
                STRTGAP = (256 - ad8)/divMan

                FrcBCK = ad4/128
                Address = 2
                HBusIn Control , Address,  [tmp1]
                Cls
                Print At 1,1, "R2: ", DEC3 bckRz, " ", DEC3 bckGz, " ", DEC3 bckBz
                Print At 2,1, "P2: ", DEC3 STRTGAP, " ", DEC3 FrcBCK
                
                For x = 0 To devNum
                    If PlsMnsZ < 127 Then
                        If x > STRZ And x < ENDZ And FrcBCK = 1 Then
                            dmR[x] = bckRz
                            dmG[x] = bckGz
                            dmB[x] = bckBz
                        Else
                            dmR[x] = 0
                            dmG[x] = 0
                            dmB[x] = 0
                        EndIf
                    Else
                        If x < STRZ And x > ENDZ And FrcBCK = 1 Then
                            dmR[x] = bckRz
                            dmG[x] = bckGz
                            dmB[x] = bckBz
                        Else
                            dmR[x] = 0
                            dmG[x] = 0
                            dmB[x] = 0
                        EndIf
                    EndIf
                Next x
                dmR[STRZ] = reve1Rz
                dmG[STRZ] = reve1Gz
                dmB[STRZ] = reve1Bz
                  
                dmR[ENDZ] = reve1Rz
                dmG[ENDZ] = reve1Gz
                dmB[ENDZ] = reve1Bz
            
                If PORTD.1 = 1 Then
                    que1 = 0
                    Address = 2
                    HBusIn Control , Address,  [tmp1]
                    If tmp1 < 45 Or tmp1 = 255 Then          '44 kayan yildiz    
                        tmp1 = tmp1 + 1
                        Address = 150 + tmp1*14
                        HBusOut Control , Address , [ STRZ, ENDZ, reve1Rz, reve1Gz, reve1Bz, PlsMnsZ, GAP, STRTGAP, bckRz, bckGz, bckBz, FrcBCK ]
                        Address = 2
                        DelayMS 200
                        HBusOut Control , Address,  [tmp1]
                        DelayMS 200
                        Cls
                        HBusIn Control , Address,  [tmp1]
                        Print At 1,1, "Record OK Q", Dec tmp1
                        DelayMS 1500
                    Else
                        Cls
                        Print At 1,1, "Memory FULL ", Dec tmp1
                        DelayMS 1500
                    EndIf
                EndIf
            EndIf
        EndIf

            
    EndIf         
    For z = 0 To moreR
        SPDk[z] = SPDk[z] + 1
        If SPDk[z] >= SPD[z] Then
            SPDk[z] = 0
        EndIf
    
    Next z
    SPDk[128] = SPDk[128] + 1
    If SPDk[128] >= SPD[128] Then
        SPDk[128] = 0
    EndIf



    revdo = 0
'noRUN
'RUN    If PORTD.1 = 1 Then
    If revrev1 = 1 Then
        GoSub reverseDm
        revdo = 1
    EndIf

    x = 0
    y = 0
    Low PORTC.6
    DelayUS break1
    High PORTC.6
    DelayUS MAB2
    RCSTA.7 = 1
    TXSTA.0 = 1
    TXSTA.2 = 1
    TXSTA.4 = 0
    TXSTA.5 = 1
    TXSTA.6 = 1
    TXSTA.0 = 1
    TXREG = sendme

'    GoSub burckaan    
'For ker = 0 To 119
'    ker3 = ker * 2
'    ker1 = dmR[ker3]
'    ker3 = ker3 + 1
'    ker2 = dmR[ker3]
'    ker3 = ker2 << 4
'    ker2 = ker3 | ker1
'    dm1[ker] = ker2
'Next ker

'For ker = 0 To 119
'    ker3 = ker * 2
'    ker1 = dmG[ker3]
'    ker3 = ker3 + 1
'    ker2 = dmG[ker3]
'    ker3 = ker2 << 4
'    ker2 = ker3 | ker1
'    dm1[(ker+120)] = ker2
'Next ker

x = 0
charouta: If PIR1.4 = 0 Then charouta    ' Wait for transmit register empty
    If x <= devNum Then
        DelayUS 3
        TXSTA.0 = 1
        TXREG = dmR[x]              ' Send character to transmit register
        x = x + 1
        If x != 0 Then
            GoTo charouta
        EndIf
    Else
        x = 0
    EndIf 
x = 0
charoutb: If PIR1.4 = 0 Then charoutb    ' Wait for transmit register empty
    If x <= devNum Then
        DelayUS 3
        TXSTA.0 = 1
        TXREG = dmG[x]              ' Send character to transmit register
        x = x + 1
        If x != 0 Then
            GoTo charoutb
        EndIf
    Else
        x = 0
    EndIf 
x = 0
charoutc: If PIR1.4 = 0 Then charoutc    ' Wait for transmit register empty
    If x <= devNum Then
        DelayUS 3
        TXSTA.0 = 1
        TXREG = dmB[x]              ' Send character to transmit register
        x = x + 1
        If x != 0 Then
            GoTo charoutc
        EndIf
    Else
        x = 0
    EndIf 
x = 0
charoutd: If PIR1.4 = 0 Then charoutd    ' Wait for transmit register empty
    If x <= 2 Then
        DelayUS 3
        TXSTA.0 = 1
        TXREG = dmB[x]              ' Send character to transmit register
        x = x + 1
        GoTo charoutd
    Else
        x = 0
    EndIf 


charout2: If PIR1.4 = 0 Then charout2
    DelayUS 140

    RCSTA.7 = 0
    TXSTA.0 = 1
    TXSTA.2 = 1
    TXSTA.4 = 0
    TXSTA.5 = 0
    TXSTA.6 = 1
    High PORTC.6    

If revdo = 1 Then
    GoSub reverseDm 
EndIf

GoTo mainLoop												' Go wait for the next buffer input



mavAddr:
    If mav = 0 Then 
        bas = 7
        son = 9
    ElseIf mav = 1 Then
        bas = 1
        son = 6
    Else
        bas = 1
        son = 9
    EndIf
    place1 = son    
    rem1 = 32
Return

DoPos1Mav0:
'yildiz
    SPD[128] = 0
    If mavPos != mav Then
        mavPos = mav
        If PORTD.1 = 0 Then
            For x = 0 To devNum
                dmtR[x] = 0
                dmtG[x] = 0
                dmtB[x] = 0
            Next x  
        EndIf
    EndIf
    GoSub iterF
    rnd1 = Random 
    y = rnd1//adc8
    For z = 1 To y
        GoSub starDo
    Next z
Return

DoPos1Mav1:
'move seperate
    If mavPos != mav Then
        mavPos = mav
    EndIf
    doItMan = 1
    GoSub iterF 
Return


DoPos1Mav2:
'move together
    If mavPos != mav Then
        mavPos = mav
    EndIf

    If aam = 0 Then
        For z = 0 To devNum
            x = ((maxB * ad4)/255)
            rnd2 = Random 
            If rnd2 > (ad4 * 256) Then
                dmtR[z] = 0    
            Else     
                dmtR[z] = rnd2//(x+1)
            EndIf
            x = ((maxB * ad5)/255)
            rnd2 = Random 
            If rnd2 > (ad5 * 256) Then
                dmtG[z] = 0    
            Else     
                dmtG[z] = rnd2//(x+1)
            EndIf
            x = ((maxB * ad6)/255)
            rnd2 = Random 
            If rnd2 > (ad6 * 256) Then
                dmtB[z] = 0    
            Else     
                dmtB[z] = rnd2//(x+1)
            EndIf
        Next z
    EndIf
    GoSub iterF
Return


DoPos1Mav3:
'kayan yildiz
    If PORTC.7 = 0 Then
        If mavPos != mav Or kk = 1 Then
            mavPos = mav
            If PORTD.1 = 0 Then
                For x = 0 To devNum
                    dmtR[x] = 0
                    dmtG[x] = 0
                    dmtB[x] = 0
                Next x  
            EndIf
            r1a = 0
            g1a = 0 
            b1a = 0
            kk = 0
        EndIf
        GoSub iterJ
        If r1a < devNum Then
            r1a = r1a + 1
        Else
            r1a = 0
        EndIf
        If g1a < devNum Then
            g1a = g1a + 1
        Else
            g1a = 0
        EndIf
        If r1a < devNum Then
            b1a = b1a + 1
        Else
            b1a = 0
        EndIf
        dmR[r1a] = reve1R
        dmG[g1a] = reve1G
        dmB[b1a] = reve1B
    Else

        Address = 2
        HBusIn Control , Address,  [tmp1]
        If tmp1 < 255 Then
            If mavPos != mav Or kk = 0 Then
                mavPos = mav
                If PORTD.1 = 0 Then
                    For x = 0 To devNum
                        dmtR[x] = 0
                        dmtG[x] = 0
                        dmtB[x] = 0
                    Next x  
                EndIf
                For q1 = 0 To tmp1
                    Address = 150 + q1*14
                    HBusIn Control , Address , [ STRZ ]
                    r1[q1] = STRZ
                Next q1
                kk = 1
            EndIf
            GoSub iterF
            For q1 = 0 To tmp1
                Address = 150 + q1*14
                HBusIn Control , Address , [ STRZ, ENDZ, reve1Rz, reve1Gz, reve1Bz, PlsMnsZ, GAP, STRTGAP, bckRz, bckGz, bckBz, FrcBCK ]
        
                
                If PlsMnsZ < 127 Then
                    If r1[q1] < ENDZ Then
                        r1[q1] = r1[q1] + PlsMnsZ
                    Else
                        r1[q1] = STRZ
                    EndIf
                Else
                    If r1[q1] > ENDZ Then
                        r1[q1] = r1[q1] + PlsMnsZ
                    Else
                        r1[q1] = STRZ
                    EndIf
                EndIf                    

                tmp2 = r1[q1]
                If PORTC.2 = 0 Then
                    dmR[tmp2] = reve1Rz
                Else
                    tmp3w = reve1Rz + dmR[tmp2]
                    If tmp3w > maxB Then
                        dmR[tmp2] = maxB
                    Else                    
                        dmR[tmp2] = reve1Rz + dmR[tmp2]
                    EndIf
                EndIf
                
                If FrcBCK = 1 Then
                    dmtR[tmp2] = bckRz * reve1R /maxB
                EndIf    
                If PORTC.2 = 0 Then
                    dmG[tmp2] = reve1Gz
                Else
                    tmp3w = reve1Gz + dmG[tmp2]
                    If tmp3w > maxB Then
                        dmG[tmp2] = maxB
                    Else                    
                        dmG[tmp2] = reve1Gz + dmG[tmp2]
                    EndIf
                EndIf
                If FrcBCK = 1 Then
                    dmtG[tmp2] = bckGz * reve1G /maxB
                EndIf    
                If PORTC.2 = 0 Then
                    dmB[tmp2] = reve1Bz
                Else
                    tmp3w = reve1Bz + dmB[tmp2]
                    If tmp3w > maxB Then
                        dmB[tmp2] = maxB
                    Else                    
                        dmB[tmp2] = reve1Bz + dmB[tmp2]
                    EndIf
                EndIf
                If FrcBCK = 1 Then
                    dmtB[tmp2] = bckBz * reve1B /maxB
                EndIf    
            Next q1
        EndIf
    EndIf    
Return


DoPos1Mav4:
'slide
    If mavPos != mav Then
        mavPos = mav
    EndIf
    For z = 0 To devNum
        If (ad4/divMan) >= z Then
            dmR[z] = reveR - 1
        Else
            dmR[z] = 0
        EndIf
        If (ad5/divMan) >= z Then
            dmG[z] = reveG - 1
        Else
            dmG[z] = 0
        EndIf
        If (ad6/divMan) >= z Then
            dmB[z] = reveB - 1
        Else
            dmB[z] = 0
        EndIf
    Next z
Return


DoPos1Mav5:
'tektek
    If mavPos != mav Then
        mavPos = mav
    EndIf
        ' Manual light-address control
        ad8i = (255-ad8)/divMan
        If ad8i >= devNum Then
            ad8i = devNum - 1
        EndIf
        ad9i = ad8i+1
        If PORTC.7 = 1 Then
            dmtR[ad8i] = maxB*ad1/255
            dmtG[ad8i] = maxB*ad2/255
            dmtB[ad8i] = maxB*ad3/255
            dmtR[ad9i] = maxB*ad4/255
            dmtG[ad9i] = maxB*ad5/255
            dmtB[ad9i] = maxB*ad6/255
        EndIf
        GoSub iterF
        SPD[128] = 0
Return

DoPos1Mav6:
'strobe
'revrev2
    If mavPos != mav Then
        mavPos = mav
    EndIf
        ' Manual light-address control
            ad8i = ad8/8
'            If hm0 = 3 and ad8i < 10 Then
'                ad8i = 10
'            EndIf 
            For z = 0 To devNum 
                If dmtR[z] = dmR[z] Then
                    If dmtR[z] = 0 Then

'RUN                        If PORTC.7 = 0 Then
'noRUN
                        If revrev2 = 0 Then
                            dmtR[z] = reve1R
                        Else
                            rnd1=Random
                            tmp4 = rnd1.LowByte 
                            tmp4 = (tmp4*reve1R)/maxB
                            dmtR[z] = tmp4/tmp
                        EndIf
                        dmR[z] = reve1R-(ad8i * reve1R)/maxB
                    Else
'RUN                        If PORTC.7 = 0 Then
'noRUN
                        If revrev2 = 0 Then
                            dmtR[z] = 0
                        Else
                            rnd1=Random
                            tmp4 = rnd1.LowByte 
                            tmp4 = (tmp4*reve1R)/maxB
                            dmtR[z] = tmp4/tmp
                        EndIf
                        dmR[z] = (ad8i * reve1R)/maxB
                    EndIf
                EndIf
                If dmtG[z] = dmG[z] Then
                    If dmtG[z] = 0 Then
'RUN                        If PORTC.7 = 0 Then
'noRUN
                        If revrev2 = 0 Then
                            dmtG[z] = reve1G
                        Else
                            rnd1=Random
                            tmp4 = rnd1.LowByte 
                            tmp4 = (tmp4*reve1G)/maxB
                            dmtG[z] = tmp4/tmp
                        EndIf
                        dmG[z] = reve1G-(ad8i * reve1G)/maxB
                    Else
'RUN                        If PORTC.7 = 0 Then
'noRUN
                        If revrev2 = 0 Then
                            dmtG[z] = 0
                        Else
                            rnd1=Random
                            tmp4 = rnd1.LowByte 
                            tmp4 = (tmp4*reve1G)/maxB
                            dmtG[z] = tmp4/tmp
                        EndIf
                        dmG[z] = (ad8i * reve1G)/maxB
                    EndIf
                EndIf
                If dmtB[z] = dmB[z] Then
                    If dmtB[z] = 0 Then
'RUN                        If PORTC.7 = 0 Then
'noRUN
                        If revrev2 = 0 Then
                            dmtB[z] = reve1B
                        Else
                            rnd1=Random
                            tmp4 = rnd1.LowByte 
                            tmp4 = (tmp4*reve1B)/maxB
                            dmtB[z] = tmp4/tmp
                        EndIf
                        dmB[z] = reve1B-(ad8i * reve1B)/maxB
                    Else
'RUN                        If PORTC.7 = 0 Then
'noRUN
                        If revrev2 = 0 Then
                            dmtB[z] = 0
                        Else
                            rnd1=Random 
                            tmp4 = rnd1.LowByte 
                            tmp4 = (tmp4*reve1B)/maxB
                            dmtB[z] = tmp4/tmp
                        EndIf
                        dmB[z] = (ad8i * reve1B)/maxB
                    EndIf
                EndIf
            Next z
            GoSub iterF
        SPD[128] = 0
Return

DoPos1Mav7:
    If mavPos != mav Then
        mavPos = mav
        For x = 0 To devNum
            dmtR[x] = 0
            dmtG[x] = 0
            dmtB[x] = 0
        Next x 
        For x = 0 To 127
            RGBif[x] = 255
        Next x
    EndIf
    GoSub iterJ
    moreX = moreR
    moreR = ad6/2
    For q1 = 0 To moreR
        
            If RGBif[q1] < 3 Then
                If SPDk[q1] = 0 Then
                'bir sonrakine gec
                    If PlsMnsZa[q1] < 127 Then
                        If r1[q1] < ENDZa[q1] Then
                            r1[q1] = r1[q1] + PlsMnsZa[q1]
                        Else
                            'r1[q1] = STRZa[q1]              macru
                            If PlsMnsZa[q1] > 8 And RGBif[q1] != 2 Then
                            'yatay
                                r1[q1] = STRZa[q1]
                                RGBif[q1] = RGBif[q1] + 1
                            Else
                                RGBif[q1] = 255  'bitir
                            EndIf
                        EndIf
                    Else
                        If r1[q1] > ENDZa[q1] Then
                            r1[q1] = r1[q1] + PlsMnsZa[q1]
                        Else
                            If PlsMnsZa[q1] < 248 And RGBif[q1] != 0 Then
                            'yatay
                                r1[q1] = STRZa[q1]
                                RGBif[q1] = RGBif[q1] - 1                        
                            Else
                                RGBif[q1] = 255  'bitir
                            EndIf
                        EndIf
                    EndIf  
                EndIf                  
                If SPD[q1] > 1 Then
                    rnd2 = Random
                    If rnd2 < 200 Then
                        SPD[q1] = SPD[q1] - 1
                    ElseIf rnd2 < 1000 Then
                        SPD[q1] = 0
                    EndIf
                EndIf
                tmp2 = r1[q1]
                If RGBif[q1] = 0 Then
                    tmp3w = reve1Rza[q1] + dmR[tmp2]
                    If tmp3w > maxB Then
                        dmR[tmp2] = maxB
                    Else                    
                        dmR[tmp2] = reve1Rza[q1] + dmR[tmp2]
                    EndIf
                ElseIf RGBif[q1] = 1 Then
                    tmp3w = reve1Rza[q1] + dmG[tmp2]
                    If tmp3w > maxB Then
                        dmG[tmp2] = maxB
                    Else                    
                        dmG[tmp2] = reve1Rza[q1] + dmG[tmp2]
                    EndIf
                ElseIf RGBif[q1] = 2 Then
                    tmp3w = reve1Rza[q1] + dmB[tmp2]
                    If tmp3w > maxB Then
                        dmB[tmp2] = maxB
                    Else                    
                        dmB[tmp2] = reve1Rza[q1] + dmB[tmp2]
                    EndIf
                EndIf
            Else
    '            seed rnd2
                
                rnd2 = Random
                ece1 = rnd2//50
    'burckaan            
                capraz = 1'PORTC.2
                If ece1 < 8 Then
                    If ece1 < 3 Then
                        If ad4 > 128 Then
                            If capraz = 1 Then
                                RGBif[q1] = ece1
                                rnd3 = Random
                                ece2 = rnd3/8192
                                STRZa[q1] = ece2 * 32
                                ENDZa[q1] = STRZa[q1] + 31
                                r1[q1] = STRZa[q1]
                                rnd2 = Random
                                reve1Rza[q1] = 1 + (rnd2//maxB)
                                PlsMnsZa[q1] = 1 '+ (rnd2//3)
                            Else
                                RGBif[q1] = ece1
                                rnd3 = Random
                                ece2 = rnd3/8192
                                STRZa[q1] = ece2 * 32
                                ENDZa[q1] = STRZa[q1] + 31
                                r1[q1] = STRZa[q1]
                                rnd2 = Random
                                reve1Rza[q1] = 1 + (rnd2//maxB)
                                PlsMnsZa[q1] = 33 '+ (rnd2//3)
                            EndIf                        
                        EndIf
                        rnd3 = Random
                        SPD[q1] = SPD[128] + rnd3/30000
                        If SPD[q1] > 1 Then
                            reve1Rza[q1] = maxB
                            SPD[q1] = 3
                        EndIf
                    ElseIf ece1 < 6 Then
                        If ad5 > 128 Then
                            If capraz = 1 Then
                                RGBif[q1] = ece1 - 3
                                rnd3 = Random
                                ece2 = rnd3/8192
                                ENDZa[q1] = ece2 * 32
                                STRZa[q1] = ENDZa[q1] + 31
                                r1[q1] = STRZa[q1]
                                rnd2 = Random
                                reve1Rza[q1] = 1 + (rnd2//maxB)
                                PlsMnsZa[q1] = 255 '+ (rnd2//3)
                            Else
                                RGBif[q1] = ece1 - 3
                                rnd3 = Random
                                ece2 = rnd3/8192
                                ENDZa[q1] = ece2 * 32
                                STRZa[q1] = ENDZa[q1] + 31
                                r1[q1] = STRZa[q1]
                                rnd2 = Random
                                reve1Rza[q1] = 1 + (rnd2//maxB)
                                PlsMnsZa[q1] = 255 '+ (rnd2//3)
                            EndIf
                        EndIf 
                        rnd3 = Random
                        SPD[q1] = SPD[128] + rnd3/30000
                        If SPD[q1] > 1 Then
                            reve1Rza[q1] = maxB
                            SPD[q1] = 3
                        EndIf
                    ElseIf ece1 = 6 Then
                        If ad2 > 128 Then
                            RGBif[q1] = 0
                            rnd3 = Random
                            ece2 = rnd3/2048
                            STRZa[q1] = ece2
                            ENDZa[q1] = STRZa[q1] + 224
                            r1[q1] = STRZa[q1]
                            rnd2 = Random
                            reve1Rza[q1] = 1 + (rnd2//maxB)
                            PlsMnsZa[q1] = 32' + (rnd2//3)
                        EndIf
                        rnd3 = Random
                        SPD[q1] = SPD[128] + rnd3/30000
                        If SPD[q1] > 1 Then
                            reve1Rza[q1] = maxB
                            SPD[q1] = 3
                        EndIf
                    ElseIf ece1 = 7 Then
                        If ad3 > 128 Then
                            RGBif[q1] = 2
                            rnd3 = Random
                            ece2 = rnd3/2048
                            ENDZa[q1] = ece2
                            STRZa[q1] = ENDZa[q1] + 224
                            r1[q1] = STRZa[q1]
                            rnd2 = Random
                            reve1Rza[q1] = 1 + (rnd2//maxB)
                            PlsMnsZa[q1] = 224' + (rnd2//3)
                        EndIf
                        rnd3 = Random
                        SPD[q1] = SPD[128] + rnd3/30000
                        If SPD[q1] > 1 Then
                            reve1Rza[q1] = maxB
                            SPD[q1] = 3
                        EndIf
                    EndIf
                EndIf
                tmp2 = r1[q1]
                If RGBif[q1] = 0 Then
                    tmp3w = reve1Rza[q1] + dmR[tmp2]
                    If tmp3w > maxB Then
                        dmR[tmp2] = maxB
                    Else                    
                        dmR[tmp2] = reve1Rza[q1] + dmR[tmp2]
                    EndIf
                ElseIf RGBif[q1] = 1 Then
                    tmp3w = reve1Rza[q1] + dmG[tmp2]
                    If tmp3w > maxB Then
                        dmG[tmp2] = maxB
                    Else                    
                        dmG[tmp2] = reve1Rza[q1] + dmG[tmp2]
                    EndIf
                ElseIf RGBif[q1] = 2 Then
                    tmp3w = reve1Rza[q1] + dmB[tmp2]
                    If tmp3w > maxB Then
                        dmB[tmp2] = maxB
                    Else                    
                        dmB[tmp2] = reve1Rza[q1] + dmB[tmp2]
                    EndIf
                EndIf
                
            EndIf

    Next q1
    If moreX > moreR Then
        moreT = moreR+1
        For q1 = moreT To moreX
            RGBif[q1] = 255
        Next q1
    EndIf
Return


DoPos1Mav8:
    If mavPos != mav Then
        mavPos = mav
        For x = 0 To devNum
            dmtR[x] = 0
            dmtG[x] = 0
            dmtB[x] = 0
        Next x 
        ece3 = 0
        rnd1 = Random
        ece1 = rnd1/2048
        STRZa[x] = ece1
        For x = 1 To 23
            rnd1 = Random
            ece1 = rnd1/22000
            STRZa[x] = STRZa[x-1] + (ece1-1)
        Next x
    EndIf
    GoSub iterJ
    If ece3 >= SPD[128] Then
        For x = 0 To 23
            rnd1 = Random
            ece1 = rnd1/22000
            If ece1 = 2 Then 
                If STRZa[x] < 31 Then   
                    STRZa[x] = STRZa[x] + (ece1-1)
                EndIf
            EndIf
            If ece1 = 0 Then 
                If STRZa[x] > 0 Then
                    STRZa[x] = STRZa[x] + (ece1-1)
                EndIf
            EndIf
        Next x
        For y = 0 To 7
            For x = 0 To 31
                If x < STRZa[y] Then
                    dmtR[((y * 32) + x)] = 0
                Else
                    dmtR[((y * 32) + x)] = ad2 - 1
                EndIf
            Next x
        Next y
        For y = 0 To 7
            For x = 0 To 31
                If x < STRZa[(y+8)] Then
                    dmtG[((y * 32) + x)] = 0
                Else
                    dmtG[((y * 32) + x)] = ad2 - 1
                EndIf
            Next x
        Next y
        For y = 0 To 7
            For x = 0 To 31
                If x < STRZa[(y+16)] Then
                    dmtB[((y * 32) + x)] = 0
                Else
                    dmtB[((y * 32) + x)] = ad2 - 1
                EndIf
            Next x
        Next y
        ece3 = 0
    Else
        ece3 = ece3 + 1
    EndIf
    
    SPD[128] = 0
Return

DoPos1Mav9:
    If mavPos != mav Then
        mavPos = mav
        For x = 0 To devNum
            dmtR[x] = 0
            dmtG[x] = 0
            dmtB[x] = 0
            dmR[x] = 0
            dmG[x] = 0
            dmB[x] = 0
        Next x
        ct1 = 0 
    EndIf
    If ct1 > 24 Then
        reveR = 130
        reveG = 130
        reveB = 130
    EndIf    
    GoSub iterJ
    If ct1 < 8 Then
        ct3 = 16+(ct1*32)
        dmR[ct3] = ad2
    ElseIf ct1 < 16 Then
        ct2 = ct1 - 8
        For x = 0 To ct2
            ct3 = 16 + x+(ct2*32) 
            dmG[ct3] =  ad2
            ct3 = 16 - x+(ct2*32)
            dmG[ct3] =  ad2
        Next x
    ElseIf ct1 < 23 Then
        ct2 = ct1 - 16
        ct4 = ct1 - 8
        For x = 0 To ct4
            ct5 = ct2
            ct3 = 16 + x+(ct5*32) 
            dmB[ct3] =  ad2
            ct3 = 16 - x+(ct5*32)
            dmB[ct3] =  ad2
        Next x
    ElseIf ct1 = 24 Then
        For x = 1 To 31
            ct5 = x + 32*7
            dmB[ct5] = ad2
        Next x
    Else
    'burada
        For x = 0 To ad5 
            rnd1 = Random 
            rndByte1 = rnd1//256
            dmR[rndByte1] = ad2
            rnd1 = Random 
            rndByte1 = rnd1//256
            dmG[rndByte1] = ad2
            rnd1 = Random 
            rndByte1 = rnd1//256
            dmB[rndByte1] = ad2
        Next x
        
    EndIf
    
            
    If ct1 < (ad6+40) Then 
        If ct1 < 255 Then      
            ct1 = ct1 + 1
        EndIf
    Else
        ct1 = 0
    EndIf    
Return



DoPos1Mav10:
    If mavPos != mav Then
        mavPos = mav
        For x = 0 To devNum
            dmtR[x] = 0
            dmtG[x] = 0
            dmtB[x] = 0
        Next x 
        For x = 24 To 127
            RGBif[x] = 255
        Next x
        For x = 0 To 7
            RGBif[x] = 0
        Next x
        For x = 8 To 15
            RGBif[x] = 1
        Next x
        For x = 16 To 23
            RGBif[x] = 2
        Next x

        For x = 0 To 23
            SPD[x] = 0
        Next x

        For x = 0 To 23
            PlsMnsZa[x] = 1
        Next x

        For x = 0 To 23
            reve1Rza[x] = maxB
        Next x
        
        For x = 0 To 23
            space1[x] = 28
        Next x


        For x = 0 To 7
            tmp3 = x
            STRZa[tmp3] = 2 + (32 * x)
            ENDZa[tmp3] = 30 + (32 * x)
        Next x

        For x = 0 To 7
            tmp3 = x + 8
            STRZa[tmp3] = 2 + (32 * x)
            ENDZa[tmp3] = 30 + (32 * x)
        Next x

        For x = 0 To 7
            tmp3 = x + 16
            STRZa[tmp3] = 2 + (32 * x)
            ENDZa[tmp3] = 30 + (32 * x)
        Next x

        For x = 0 To 7
            tmp2 = x
            tmp3 = tmp2 + 4
            r1[tmp2] = tmp3 + (32*x)
        Next x
        For x = 0 To 7
            tmp2 = x+8
            tmp3 = tmp2 + 4
            r1[tmp2] = tmp3 + (32*x)
        Next x
        For x = 0 To 7
            tmp2 = x+16
            tmp3 = tmp2 + 4
            r1[tmp2] = tmp3 + (32*x)
        Next x


        remmi = 2 - ad4/56
        moreR = 23
    EndIf
    GoSub iterJ

    moreR = 23
    For q1 = moreR To 0 Step -1
        If RGBif[q1] < 3 Then
            'bir sonrakine gec
            If PlsMnsZa[q1] < 127 Then
                If r1[q1] < ENDZa[q1] Then
                    r1[q1] = r1[q1] + PlsMnsZa[q1]
                Else
                    If PlsMnsZa[q1] > 8 And RGBif[q1] != 2 Then
                    'yatay
                        r1[q1] = STRZa[q1]
                        RGBif[q1] = RGBif[q1] + 1
                    Else
                        tmp3 = STRZa[q1]
                        STRZa[q1] = ENDZa[q1]
                        ENDZa[q1] = tmp3
                        PlsMnsZa[q1] = 255
                        If SPD[q1] = 0 Then
                            SPD[q1] = 0
                            remmi1 = q1
                            If remmi < 5 Then
                                If space1[q1] >= remmi Then
                                    ENDZa[q1] = ENDZa[q1] + remmi
                                    space1[q1] = space1[q1] - remmi
                                EndIf
                            Else
                                tmp3 = 28 + remmi     
                                If space1[q1] <= tmp3 Then
                                    ENDZa[q1] = ENDZa[q1] + remmi
                                    space1[q1] = space1[q1] - remmi
                                EndIf
                            EndIf
                        Else
                            SPD[q1] = SPD[q1] - 1
                        EndIf
                    EndIf
                EndIf
            Else
                If r1[q1] > ENDZa[q1] Then
                    r1[q1] = r1[q1] + PlsMnsZa[q1]
                Else
                    If PlsMnsZa[q1] < 248 And RGBif[q1] != 0 Then
                    'yatay
                        r1[q1] = STRZa[q1]
                        RGBif[q1] = RGBif[q1] - 1                        
                    Else
                        tmp3 = STRZa[q1]
                        STRZa[q1] = ENDZa[q1]
                        ENDZa[q1] = tmp3
                        PlsMnsZa[q1] = 1
                        If SPD[q1] = 0 Then
                            SPD[q1] = 0
                            remmi1 = q1
                            If remmi < 5 Then
                                If space1[q1] >= remmi Then
                                    ENDZa[q1] = ENDZa[q1] - remmi
                                    space1[q1] = space1[q1] - remmi
                                EndIf
                            Else
                                tmp3 = 28 + remmi     
                                If space1[q1] <= tmp3 Then
                                    ENDZa[q1] = ENDZa[q1] - remmi
                                    space1[q1] = space1[q1] - remmi
                                EndIf
                            EndIf
                        Else
                            SPD[q1] = SPD[q1] - 1
                        EndIf
                    EndIf
                EndIf
            EndIf  
            tmp2 = r1[q1]
            If RGBif[q1] = 0 Then
                tmp3w = reve1Rza[q1] + dmR[tmp2]
                If tmp3w > maxB Then
                    dmR[tmp2] = maxB
                Else                    
                    dmR[tmp2] = reve1Rza[q1] + dmR[tmp2]
                EndIf
            ElseIf RGBif[q1] = 1 Then
                tmp3w = reve1Rza[q1] + dmG[tmp2]
                If tmp3w > maxB Then
                    dmG[tmp2] = maxB
                Else                    
                    dmG[tmp2] = reve1Rza[q1] + dmG[tmp2]
                EndIf
            ElseIf RGBif[q1] = 2 Then
                tmp3w = reve1Rza[q1] + dmB[tmp2]
                If tmp3w > maxB Then
                    dmB[tmp2] = maxB
                Else                    
                    dmB[tmp2] = reve1Rza[q1] + dmB[tmp2]
                EndIf
            EndIf
        EndIf

        tmp3 = remmi - 2 + ad4/56
        If tmp3 > 0 Then
            If remmi1 = 0 Then
                remmi = 2 - ad4/56
            EndIf
        Else
            If remmi1 = moreR Then
                remmi = 2 - ad4/56
            EndIf
        EndIf
    Next q1
Return

DoPos1Mav11:
    If mavPos != mav Then
        mavPos = mav
        For x = 0 To devNum
            dmtR[x] = 0
            dmtG[x] = 0
            dmtB[x] = 0
        Next x 
        For x = 48 To 127
            RGBif[x] = 255
        Next x
        For x = 0 To 7
            RGBif[x] = 0
        Next x
        For x = 8 To 15
            RGBif[x] = 1
        Next x
        For x = 16 To 23
            RGBif[x] = 2
        Next x

        For x = 24 To 31
            RGBif[x] = 0
        Next x
        For x = 32 To 39
            RGBif[x] = 1
        Next x
        For x = 40 To 47
            RGBif[x] = 2
        Next x


        For x = 0 To 47
            SPD[x] = 0
        Next x

        For x = 0 To 23
            PlsMnsZa[x] = 1
        Next x
        For x = 24 To 47
            PlsMnsZa[x] = 255
        Next x

        For x = 0 To 47
            reve1Rza[x] = maxB
        Next x

        For x = 0 To 47
            space1[x] = 28
        Next x
        
        For x = 0 To 7
            tmp3 = x
            STRZa[tmp3] = 2 + (32 * x)
            ENDZa[tmp3] = 30 + (32 * x)
        Next x
        For x = 0 To 7
            tmp3 = x+24
            ENDZa[tmp3] = 2 + (32 * x)
            STRZa[tmp3] = 30 + (32 * x)
        Next x

        For x = 0 To 7
            tmp3 = x + 8
            STRZa[tmp3] = 2 + (32 * x)
            ENDZa[tmp3] = 30 + (32 * x)
        Next x
        For x = 0 To 7
            tmp3 = x + 32
            ENDZa[tmp3] = 2 + (32 * x)
            STRZa[tmp3] = 30 + (32 * x)
        Next x

        For x = 0 To 7
            tmp3 = x + 16
            STRZa[tmp3] = 2 + (32 * x)
            ENDZa[tmp3] = 30 + (32 * x)
        Next x
        For x = 0 To 7
            tmp3 = x + 40
            ENDZa[tmp3] = 2 + (32 * x)
            STRZa[tmp3] = 30 + (32 * x)
        Next x

        For x = 0 To 7 
            tmp2 = x
            tmp3 = tmp2 + 4
            r1[tmp2] = tmp3 + (32*x)
        Next x
        For x = 0 To 7
            tmp2 = x+8
            tmp3 = tmp2 + 4
            r1[tmp2] = tmp3 + (32*x)
        Next x
        For x = 0 To 7
            tmp2 = x+16
            tmp3 = tmp2 + 4
            r1[tmp2] = tmp3 + (32*x)
        Next x     
        For x = 0 To 7 
            tmp2 = x
            tmp3 = 28-tmp2
            tmp2 = x+24
            r1[tmp2] = tmp3 + (32*x)
        Next x
        For x = 0 To 7
            tmp2 = x+8
            tmp3 = 28-tmp2
            tmp2 = x+32
            r1[tmp2] = tmp3 + (32*x)
        Next x
        For x = 0 To 7
            tmp2 = x+16
            tmp3 = 28-tmp2
            tmp2 = x+40
            r1[tmp2] = tmp3 + (32*x)
        Next x



        moreR = 47
        remmi = 2 - ad4/56
    EndIf
    GoSub iterJ

    moreR = 47

    For q1 = moreR To 0 Step -1
        If RGBif[q1] < 3 Then
            'bir sonrakine gec
            If PlsMnsZa[q1] < 127 Then
                If r1[q1] < ENDZa[q1] Then
                    r1[q1] = r1[q1] + PlsMnsZa[q1]
                Else
                    If PlsMnsZa[q1] > 8 And RGBif[q1] != 2 Then
                    'yatay
                        r1[q1] = STRZa[q1]
                        RGBif[q1] = RGBif[q1] + 1
                    Else
                        tmp3 = STRZa[q1]
                        STRZa[q1] = ENDZa[q1]
                        ENDZa[q1] = tmp3
                        PlsMnsZa[q1] = 255
                        If SPD[q1] = 0 Then
                            SPD[q1] = 0
                            remmi1 = q1
                            If remmi < 5 Then
                                If space1[q1] >= remmi Then
                                    ENDZa[q1] = ENDZa[q1] + remmi
                                    space1[q1] = space1[q1] - remmi
                                EndIf
                            Else
                                tmp3 = 28 + remmi     
                                If space1[q1] <= tmp3 Then
                                    ENDZa[q1] = ENDZa[q1] + remmi
                                    space1[q1] = space1[q1] - remmi
                                EndIf
                            EndIf
                        Else
                            SPD[q1] = SPD[q1] - 1
                        EndIf
                    EndIf
                EndIf
            Else
                If r1[q1] > ENDZa[q1] Then
                    r1[q1] = r1[q1] + PlsMnsZa[q1]
                Else
                    If PlsMnsZa[q1] < 248 And RGBif[q1] != 0 Then
                    'yatay
                        r1[q1] = STRZa[q1]
                        RGBif[q1] = RGBif[q1] - 1                        
                    Else
                        tmp3 = STRZa[q1]
                        STRZa[q1] = ENDZa[q1]
                        ENDZa[q1] = tmp3
                        PlsMnsZa[q1] = 1
                        If SPD[q1] = 0 Then
                            SPD[q1] = 0
                            remmi1 = q1
                            If remmi < 5 Then
                                If space1[q1] >= remmi Then
                                    ENDZa[q1] = ENDZa[q1] - remmi
                                    space1[q1] = space1[q1] - remmi
                                EndIf
                            Else
                                tmp3 = 28 + remmi     
                                If space1[q1] <= tmp3 Then
                                    ENDZa[q1] = ENDZa[q1] - remmi
                                    space1[q1] = space1[q1] - remmi
                                EndIf
                            EndIf
                        Else
                            SPD[q1] = SPD[q1] - 1
                        EndIf
                    EndIf
                EndIf
            EndIf  
            tmp2 = r1[q1]
            If RGBif[q1] = 0 Then
                tmp3w = reve1Rza[q1] + dmR[tmp2]
                If tmp3w > maxB Then
                    dmR[tmp2] = maxB
                Else                    
                    dmR[tmp2] = reve1Rza[q1] + dmR[tmp2]
                EndIf
            ElseIf RGBif[q1] = 1 Then
                tmp3w = reve1Rza[q1] + dmG[tmp2]
                If tmp3w > maxB Then
                    dmG[tmp2] = maxB
                Else                    
                    dmG[tmp2] = reve1Rza[q1] + dmG[tmp2]
                EndIf
            ElseIf RGBif[q1] = 2 Then
                tmp3w = reve1Rza[q1] + dmB[tmp2]
                If tmp3w > maxB Then
                    dmB[tmp2] = maxB
                Else                    
                    dmB[tmp2] = reve1Rza[q1] + dmB[tmp2]
                EndIf
            EndIf
        EndIf

        tmp3 = remmi - 2 + ad4/56
        If tmp3 > 0 Then
            If remmi1 = 0 Then
                remmi = 2 - ad4/56
            EndIf
        Else
            If remmi1 = moreR Then
                remmi = 2 - ad4/56
            EndIf
        EndIf
    Next q1
Return


progExe:
    If aam = 0 Then
        If rem1.7 = 1 Then
            rem1 = rem1 + 32    
            If place1 = bas Then
                place1 = son
            Else
                place1 = place1 - 1
            EndIf 
        EndIf
        If rem1.7 = 0 And rem1 > 31 Then
            rem1 = rem1 - 32
            If place1 = son Then
                place1 = bas
            Else
                place1 = place1 + 1
            EndIf
        EndIf
        If place1 = son Then
            place2 = bas
        Else
            place2 = place1 + 1
        EndIf
        AddRed1[0] = place1 * 768 + rem1 * 8
        AddRed1[1] = place2 * 768
        rem1x = 8*(31 - rem1)



        Address = AddRed1[0]
        For x = 0 To 248 Step 8            ' Create a loop
            HBusIn Control , Address , [ dmtR[x], dmtR[x + 1], dmtR[x + 2], dmtR[x + 3], dmtR[x + 4], dmtR[x + 5], dmtR[x + 6], dmtR[x + 7] ]
            If rem1x = x Then
                Address = AddRed1[1]
            Else       
                Address = Address + 8
            EndIf
        Next   
        Address = AddRed1[0] + 256
        For x = 0 To 248 Step 8            ' Create a loop
            HBusIn Control , Address , [ dmtG[x], dmtG[x + 1], dmtG[x + 2], dmtG[x + 3], dmtG[x + 4], dmtG[x + 5], dmtG[x + 6], dmtG[x + 7] ]
            If rem1x = x Then
                Address = AddRed1[1] + 256
            Else       
                Address = Address + 8
            EndIf
        Next   
        Address = AddRed1[0] + 512
        For x = 0 To 248 Step 8            ' Create a loop
            HBusIn Control , Address , [ dmtB[x], dmtB[x + 1], dmtB[x + 2], dmtB[x + 3], dmtB[x + 4], dmtB[x + 5], dmtB[x + 6], dmtB[x + 7] ]
            If rem1x = x Then
                Address = AddRed1[1] + 512
            Else       
                Address = Address + 8
            EndIf
        Next   






        rem1 = rem1 + ad8w
        aam = 1
    EndIf
    GoSub iterF
Return

iterJ:
        aam = 0 
        For x = 0 To devNum
            If dmR[x] > dmtR[x] Then
                If reveR < dmR[x] - dmtR[x] Then
                    dmR[x] = dmR[x] - reveR
                    aam = 1
                Else
                    dmR[x] = dmtR[x]  
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtR[x] = rndByte2
                    EndIf
                EndIf
            Else
                If reveR < dmtR[x] - dmR[x] Then
                    dmR[x] = dmR[x] + reveR
                    aam = 1
                Else
                    dmR[x] = dmtR[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtR[x] = rndByte2
                    EndIf
                EndIf
            EndIf
            If dmG[x] > dmtG[x] Then
                If reveG < dmG[x] - dmtG[x] Then
                    dmG[x] = dmG[x] - reveG
                    aam = 1
                Else
                    dmG[x] = dmtG[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtG[x] = rndByte2
                    EndIf
                EndIf
            Else
                If reveG < dmtG[x] - dmG[x] Then
                    dmG[x] = dmG[x] + reveG
                    aam = 1
                Else
                    dmG[x] = dmtG[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtG[x] = rndByte2
                    EndIf
                EndIf
            EndIf
            If dmB[x] > dmtB[x] Then
                If reveB < dmB[x] - dmtB[x] Then
                    dmB[x] = dmB[x] - reveB
                    aam = 1
                Else
                    dmB[x] = dmtB[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtB[x] = rndByte2
                    EndIf
                EndIf
            Else
                If reveB < dmtB[x] - dmB[x] Then
                    dmB[x] = dmB[x] + reveB
                    aam = 1
                Else
                    dmB[x] = dmtB[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtB[x] = rndByte2
                    EndIf
                EndIf
            EndIf
        Next x
Return


iterF:
    aam = 0 
        For x = 0 To devNum
            If dmR[x] > dmtR[x] Then
                If reveR < dmR[x] - dmtR[x] Then
                    dmR[x] = dmR[x] - reveR
                    aam = 1
                Else
                    dmR[x] = dmtR[x]  
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtR[x] = rndByte2
                    EndIf
                EndIf
            Else
                If reveR < dmtR[x] - dmR[x] Then
                    dmR[x] = dmR[x] + reveR
                    aam = 1
                Else
                    dmR[x] = dmtR[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtR[x] = rndByte2
                    EndIf
                EndIf
            EndIf
            If dmG[x] > dmtG[x] Then
                If reveG < dmG[x] - dmtG[x] Then
                    dmG[x] = dmG[x] - reveG
                    aam = 1
                Else
                    dmG[x] = dmtG[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtG[x] = rndByte2
                    EndIf
                EndIf
            Else
                If reveG < dmtG[x] - dmG[x] Then
                    dmG[x] = dmG[x] + reveG
                    aam = 1
                Else
                    dmG[x] = dmtG[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtG[x] = rndByte2
                    EndIf
                EndIf
            EndIf
            If dmB[x] > dmtB[x] Then
                If reveB < dmB[x] - dmtB[x] Then
                    dmB[x] = dmB[x] - reveB
                    aam = 1
                Else
                    dmB[x] = dmtB[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtB[x] = rndByte2
                    EndIf
                EndIf
            Else
                If reveB < dmtB[x] - dmB[x] Then
                    dmB[x] = dmB[x] + reveB
                    aam = 1
                Else
                    dmB[x] = dmtB[x]   
                    If doItMan = 1 Then
                        z = ((maxB * ad2)/255)
                        rnd2 = Random 
                        rndByte2 = rnd2//(z+1)
                        dmtB[x] = rndByte2
                    EndIf
                EndIf
            EndIf
        Next x
Return

starDo:
    rnd1 = Random 
    If maxB = 31 Then
        If hm0 = 9 Then
            rndByte1 = rnd1//256
        Else
            rndByte1 = rnd1//256
        EndIf
    Else
        rndByte1 = rnd1//256
    EndIf
    x = ((maxB * ad4)/255)
    rnd2 = Random 
    rndByte2 = rnd2//(x+1)
    rnd2 = Random 
    x = rnd2//3
    If x = 0 Then       
        dmR[rndByte1] = rndByte2
    ElseIf x = 1 Then
        dmG[rndByte1] = rndByte2
    Else
        dmB[rndByte1] = rndByte2
    EndIf
Return	
reverseDm:
    For x = 0 To 255
        dmR[x] = 255 - dmR[x]
    Next x
    For x = 0 To 255
        dmG[x] = 255 - dmG[x]
    Next x
    For x = 0 To 255
        dmB[x] = 255 - dmB[x]
    Next x
Return







rotator:
'burckaan:      
    tri2 = tri1
    tri1.0 = PORTB.7
    tri1.1 = PORTB.5 
    If tri1 != tri2 Then
        If tri1 = 2 Or tri2 = 2 Then   
            tri3 = 220000
            GoTo loop1
        EndIf
        If tri1 = 1 Or tri2 = 1 Then   
            tri3 = 220000
            GoTo loop2
        EndIf
        If tri1 = 0 Then   
            tri3 = 220000
            GoTo loop4
        EndIf
    EndIf
    GoTo loop3
loop4:
    tri1.0 = PORTB.7
    tri1.1 = PORTB.5 
    If tri1 = 3 Then
        tri2 = 3
        GoTo loop3
    ElseIf tri1 = 1 Then
        art = 1 
        tri2 = tri1  
        GoTo loop3
    ElseIf tri1 = 2 Then
        art = 255 
        tri2 = tri1  
        GoTo loop3
    EndIf
    tri3 = tri3 - 1 
    If tri3 > 0 Then
        GoTo loop4
    Else
        tri2 = tri1
        GoTo loop3
    EndIf
loop1:                 
    tri1.0 = PORTB.7
    tri1.1 = PORTB.5 
    If tri1 = 3 Then
        tri2 = 3
        GoTo loop3
    ElseIf tri1 = 0 Then
        tri3 = 220000
        tri2 = 0   
    ElseIf tri1 = 1 And tri2 = 0 Then
        art = 1 
        tri2 = tri1  
        GoTo loop3
    ElseIf tri1 = 1 Then
        tri2 = tri1  
        GoTo loop3
    EndIf
    tri3 = tri3 - 1 
    If tri3 > 0 Then
        GoTo loop1
    Else
        tri2 = tri1
        GoTo loop3
    EndIf
loop2:
    tri1.0 = PORTB.7
    tri1.1 = PORTB.5 
    If tri1 = 3 Then
        tri2 = 3
        GoTo loop3
    ElseIf tri1 = 0 Then
        tri3 = 220000
        tri2 = 0   
    ElseIf tri1 = 2 And tri2 = 0 Then
        art = 255 
        tri2 = tri1  
        GoTo loop3
    ElseIf tri1 = 2 Then
        tri2 = tri1  
        GoTo loop3
    EndIf
    tri3 = tri3 - 1 
    If tri3 > 0 Then
        GoTo loop2
    Else
        tri2 = tri1
        GoTo loop3
    EndIf
loop3:
    If PORTB.4 = 0 Then
        art = 10
    EndIf
    If art != 0 Then
        If art = 10 Then
            mav = 0
        Else    
            If mav = 0 And art != 1 Then
                mav = mavMax 
            ElseIf mav = mavMax And art = 1 Then
                mav = 0           
            Else
                mav = mav + art
            EndIf
        EndIf
        EWrite 1, [ mav ]
        GoSub mavAddr
        Cls
        Print At 1,1, "Mod",Dec hm0, " art:", DEC3 mav 
        art = 0
    EndIf
Return

rotator1:
    revrev1 = 0
    cnt1 = cnt1 + 1
    If cnt1 = cnt4 Then
        cnt2 = cnt2 + 1
        cnt1 = 0
    EndIf

    If cnt2 < 230 Then
        cnt4 = 3
        mav = 0 
        ad1 = 20 + cnt2
        ad2 = 255
        ad4 = 255
        ad8 = 230 - cnt2
    ElseIf cnt2 < 485 Then
        cnt4 = 3
        mav = 8
        cnt3 = cnt2 - 230
        ad1 = cnt3
        ad2 = ad1
        ad8 = 0
    ElseIf cnt2 < 740 Then
        If cnt4 = 0 And cnt2 = 485 Then
               For x = 0 To devNum
                    dmtR[x] = 0
                    dmtG[x] = 0
                    dmtB[x] = 0
                    dmR[x] = 0
                    dmG[x] = 0
                    dmB[x] = 0
               Next x
        EndIf
        
        cnt4 = 3
        mav = 6
        cnt3 = cnt2 - 485
        ad1 = 23
        ad2 = ad1
        ad8 = cnt3
        ad4 = 255 
        ad5 = 255
        ad6 = 255
        If cnt3 > 240 Then
            revrev1 = 1
            revrev2 = 0
        ElseIf cnt3 > 220 Then
            revrev2 = 1
        ElseIf cnt3 > 200 Then
            revrev2 = 0
        ElseIf cnt3 > 170 Then
            revrev2 = 1
        ElseIf cnt3 > 140 Then
            revrev2 = 0
        ElseIf cnt3 > 120 Then
            revrev2 = 1
        ElseIf cnt3 > 100 Then
            revrev2 = 0
        ElseIf cnt3 > 80 Then
            revrev2 = 1
        ElseIf cnt3 > 60 Then
            revrev2 = 0
        ElseIf cnt3 > 40 Then
            revrev2 = 1
        ElseIf cnt3 > 20 Then
            revrev2 = 0
        EndIf
    ElseIf cnt2 < 995 Then
        cnt4 = 3
        mav = 7
        cnt3 = cnt2 - 740
        ad1 = cnt3
        ad2 = 0
        ad3 = 0
        ad4 = 200
        ad5 = 0
        ad6 = cnt3
        ad8 = 0
        If cnt3 = 200 Then
            revrev1 = 1
        EndIf
        If cnt3 = 230 And cnt1 = 1 Then
            revrev1 = 1
        EndIf
        If cnt3 = 233 And cnt1 = 1 Then
            revrev1 = 1
        EndIf
        If cnt3 = 240 Then
            revrev1 = 1
        EndIf
        If cnt3 = 241 And cnt1 = 1 Then
            revrev1 = 1
        EndIf
        If cnt3 = 242 And cnt1 = 1 Then
            revrev1 = 1
        EndIf
        
    ElseIf cnt2 < 1250 Then
        cnt4 = 3
        mav = 7
        cnt3 = cnt2 - 995
        ad6 = cnt3
        ad8 = 0
        If cnt3 < 10 Then
            ad1 = 15
            ad2 = 0
            ad3 = 0
            ad4 = 200
            ad5 = 0
        ElseIf cnt3 < 12 Then
            ad1 = 15
            ad2 = 0
            ad3 = 0
            ad4 = 0
            ad5 = 200
        ElseIf cnt3 < 16 Then
            ad1 = 15
            ad2 = 0
            ad3 = 200
            ad4 = 0
            ad5 = 0
        ElseIf cnt3 < 18 Then
            ad1 = 15
            ad2 = 200
            ad3 = 0
            ad4 = 0
            ad5 = 0
        ElseIf cnt3 < 25 Then
            ad1 = 64
            ad2 = 200
            ad3 = 200
            ad4 = 200
            ad5 = 200
        ElseIf cnt3 < 46 Then
            ad1 = 32
            ad2 = 0
            ad3 = 0
            ad4 = 200
            ad5 = 200
        ElseIf cnt3 < 70 Then
            ad1 = 32
            ad2 = 200
            ad3 = 0
            ad4 = 200
            ad5 = 0
        ElseIf cnt3 < 90 Then
            ad1 = 32
            ad2 = 0
            ad3 = 0
            ad4 = 0
            ad5 = 200
        ElseIf cnt3 < 140 Then
            ad1 = 32
            ad2 = 0
            ad3 = 0
            ad4 = 200
            ad5 = 200
        ElseIf cnt3 < 180 Then
            ad1 = 64
            ad2 = 200
            ad3 = 200
            ad4 = 200
            ad5 = 200
        ElseIf cnt3 < 220 Then
            ad1 = 15
            ad2 = 200
            ad3 = 200
            ad4 = 0
            ad5 = 0
        Else
            ad1 = 16
            ad2 = 200
            ad3 = 200
            ad4 = 200
            ad5 = 200
        EndIf



    ElseIf cnt2 < 1505 Then
        cnt4 = 3
        mav = 9
        cnt3 = cnt2 - 1250
        ad1 = 23
        ad2 = 255
        ad3 = 0
        ad4 = 0
        ad6 = 120
        ad8 = 0
        If ct1 > 24 Then
            If 125 > ct1 Then
                ad5 = 125 - ct1
            EndIf
        EndIf    

    ElseIf cnt2 < 1650 Then
        cnt4 = 3
        mav = 10
        cnt3 = cnt2 - 1505
        ad1 = 6 + cnt3/2
        ad2 = 255
        ad3 = 0
        ad4 = 70
        ad6 = 0
        ad8 = 0

    ElseIf cnt2 < 1750 Then
        cnt4 = 3
        mav = 11
        cnt3 = cnt2 - 1650
        ad1 = 6 + cnt3/2
        ad2 = 255
        ad3 = 0
        ad4 = 128
        ad6 = 0
        ad8 = 0
    ElseIf cnt2 < 1850 Then
        cnt4 = 3
        mav = 11
        cnt3 = 1850 - cnt2
        ad1 = 6 + cnt3/2
        ad2 = 255
        ad3 = 0
        ad4 = 128
        ad6 = 0
        ad8 = 0
    ElseIf cnt2 < 2000 Then
        cnt4 = 3
        mav = 11
        cnt3 = cnt2 - 1850
        ad1 = 6 + cnt3/2
        ad2 = 255
        ad3 = 0
        ad4 = 70
        ad6 = 0
        ad8 = 0



    Else
        cnt2 = 0
    EndIf
            
Return

End
