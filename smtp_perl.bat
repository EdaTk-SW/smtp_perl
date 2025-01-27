@echo off
set HERE=%~dp0
if #%HERE:~-1%# == #\# set HERE=%HERE:~0,-1%
goto :StartCode
'================================================================================================================
'
' �2024 SIEMENS EDA. All Rights Reserved.
'
' This software or file (the "Material") contains trade secrets or otherwise confidential information owned by
' Siemens Industry Software Inc. or its affiliates (collectively, "SISW"), or SISW's licensors. Access to and use
' of this information is strictly limited as set forth in one or more applicable agreement(s) with SISW. This
' Material may not be copied, distributed, or otherwise disclosed without the express written permission of SISW,
' and may not be used in any way not expressly authorized by SISW.
'
' Unless otherwise agreed in writing, SISW has no obligation to support or otherwise maintain this Material.
' No representation or other affirmation of fact herein shall be deemed to be a warranty or give rise to any
' liability of SISW whatsoever.
'
' SISW reserves the right to make changes in specifications and other information contained herein without prior
' notice, and the reader should, in all cases, consult SISW to determine whether any changes have been made.
'
' SISW MAKES NO WARRANTY OF ANY KIND WITH REGARD TO THIS MATERIAL INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
' WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT OF INTELLECTUAL PROPERTY.
' SISW SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, CONSEQUENTIAL OR PUNITIVE DAMAGES, LOST DATA OR
' PROFITS, EVEN IF SUCH DAMAGES WERE FORESEEABLE, ARISING OUT OF OR RELATED TO THIS PUBLICATION OR THE
' INFORMATION CONTAINED IN IT, EVEN IF SISW HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
'
' TRADEMARKS: The trademarks, logos, and service marks (collectively, "Marks") used herein are the property of
' Siemens AG, SISW, or their affiliates (collectively, "Siemens") or other parties. No one is permitted to use
' these Marks without the prior written consent of Siemens or the owner of the Marks, as applicable. The use
' herein of third party Marks is not an attempt to indicate Siemens as a source of a product, but is intended to
' indicate a product from, or associated with, a particular third party. A list of Siemens' Marks may be viewed
' at: www.plm.automation.siemens.com/global/en/legal/trademarks.html
'
'================================================================================================================
'
' File:    smtp_perl.bat
'
' Author:  Don Waldoch
'
' Revision History:
'
'   1.00  06/04/24  DTW  Initial Release.
'
'================================================================================================================
:StartCode

set FILE="%HERE%\%~n0.pl"

set PERL="C:\Perl64\5_36_3\bin\perl.exe"
set PERL="%EDATK_PERL%\bin\perl.exe"

%PERL% -w %FILE% %*

echo.
pause
exit /b 0
