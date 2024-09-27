<%@ Page Language="C#" MasterPageFile="~/BPMUITemplates/Default/Repository/Site/HTML5MasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" Inherits="Skelta.Repository.Web.CodeBehind.HomePage1" Title="Untitled Page" %>

<%@ Register Src="WebPartManager.ascx" TagName="ECWebPartManager"
    TagPrefix="uc1" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MenuTitle" runat="server"> 
    <div>		
         <%=resourceManager.GlobalResourceSet.GetString("ec_menu_webpartdashboard") %>							
    </div>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="Cont" runat="Server">
    <div ID="rightCornerDayLimit" style="width: 100%; height: 10%; position: absolute; text-align: right; color: red; padding-right: 20px; text-size-adjust: 20px;">
        Your password will expire in 65 days
    </div>
    <div style="width: 100%; height: 90%; position: absolute;" id="contentArea">
        <uc1:ECWebPartManager ID="ECWebPartManager1" runat="server" />
        <div style="height: 50%; width: 100%; position: relative; overflow: auto; border: 1px solid #cccccc;">
            <div id="divHeader" class="ContainerWebPartZone" style="height: 75%; width: 100%;">
                <asp:WebPartZone ID="WebPartZoneHeader" HeaderText="Web Part Zone Header" Width="100%"
                    Height="90%" runat="server" ShowTitleIcons="true" CssClass="WebPartZone"
                    LayoutOrientation="Vertical">
                    <PartChromeStyle CssClass="PartChromeStyle" />
                    <MenuLabelHoverStyle CssClass="MenuLabelHoverStyle" />
                    <EmptyZoneTextStyle Font-Size="0.8em" />
                    <MenuLabelStyle CssClass="MenuLabelStyle" />
                    <MenuVerbHoverStyle CssClass="MenuVerbHoverStyle" BorderWidth="1px" />
                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Center" Font-Size="0.7em" />
                    <MenuVerbStyle ForeColor="Gray" Font-Size="8" />
                    <TitleBarVerbStyle CssClass="TitleBarVerbStyle" Font-Underline="false" />
                    <MenuPopupStyle Font-Names="Verdana" BackColor="White" BorderColor="LightGray" BorderWidth="1px" />
                    <PartTitleStyle Font-Size="0.7em" ForeColor="#003399" />
                </asp:WebPartZone>
            </div>
        </div>
        <div style="height: 50%; position: relative;">
            <div id="content" style="width: 50%; height: 100%; float: left; position: absolute;">
                <div id="divLeft" class="ContainerWebPartZone" style="height: 82%; width: 98%; overflow: auto; border: 1px solid #cccccc;">
                    <asp:WebPartZone ID="WebPartZoneLeft" HeaderText="Web Part Zone Left" Width="97%"
                        Height="90%" runat="server" CssClass="WebPartZone"
                        LayoutOrientation="Vertical">
                        <PartChromeStyle CssClass="PartChromeStyle" BorderStyle="None" />
                        <MenuLabelHoverStyle CssClass="MenuLabelHoverStyle" />
                        <EmptyZoneTextStyle Font-Size="0.8em" />
                        <MenuLabelStyle CssClass="MenuLabelStyle" />
                        <MenuVerbHoverStyle CssClass="MenuVerbHoverStyle" BorderWidth="1px" />
                        <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Center" Font-Size="0.7em" />
                        <MenuVerbStyle ForeColor="Gray" Font-Size="8" BorderWidth="0" />
                        <TitleBarVerbStyle CssClass="TitleBarVerbStyle" Font-Underline="false" />
                        <MenuPopupStyle Font-Names="Verdana" BackColor="White" BorderColor="LightGray" />
                        <PartTitleStyle Font-Size="0.7em" ForeColor="#003399" />
                    </asp:WebPartZone>
                </div>
            </div>
            <div style="width: 50%; height: 82%; float: right; position: relative; overflow: auto; border: 1px solid #cccccc;" class="runtext">
                <div id="divRight" class="ContainerWebPartZone" style="height: 100%; width: 100%;">
                    <asp:WebPartZone ID="WebPartZoneRight" HeaderText="Web Part Zone Right" Width="100%"
                        Height="90%" runat="server" CssClass="WebPartZone"
                        LayoutOrientation="Vertical">
                        <PartChromeStyle CssClass="PartChromeStyle" />
                        <MenuLabelHoverStyle CssClass="MenuLabelHoverStyle" />
                        <EmptyZoneTextStyle Font-Size="0.8em" />
                        <MenuLabelStyle CssClass="MenuLabelStyle" />
                        <MenuVerbHoverStyle CssClass="MenuVerbHoverStyle" BorderWidth="1px" />
                        <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Center" Font-Size="0.7em" />
                        <MenuVerbStyle ForeColor="Gray" Font-Size="8" />
                        <TitleBarVerbStyle CssClass="TitleBarVerbStyle" Font-Underline="false" />
                        <MenuPopupStyle Font-Names="Verdana" BackColor="White" BorderColor="LightGray" BorderWidth="1px" />
                        <PartTitleStyle Font-Size="0.7em" ForeColor="#003399" />
                    </asp:WebPartZone>
                </div>
            </div>
        </div>
    </div>


    <script>
        try {
            document.getElementById("tblMain").style.display = "none";
        } catch (ex) { }

        // Attach event listener to the content area

        function loadNewWindow() {
            const userName = document.getElementById("ctl00_userNamePlaceholder").textContent.split('\\').pop();

            const newWindow = window.open(
                `https://localhost:8002/index?userName=${encodeURIComponent(userName)}`,
                '_blank',
                'width=400,height=400'
            );

            if (newWindow) {
                setTimeout(() => {
                    const windowWidth = window.innerWidth;
                    const windowHeight = window.innerHeight;
                    const newWindowWidth = 400;
                    const newWindowHeight = 400;
                    const left = (windowWidth - newWindowWidth) / 2;
                    const top = (windowHeight - newWindowHeight) / 2;

                    newWindow.moveTo(left, top);
                    newWindow.document.title = "New Title for Window";
                }, 100); // Adjust timeout as necessary

                // Check for daysRemaining after a delay
                setTimeout(() => {
                    if (newWindow.daysRemaining) {
                        const daysRemaining = newWindow.daysRemaining; // Get the daysRemaining
                        console.log(`Days remaining: ${daysRemaining}`);
                    }
                }, 2000); // Wait for a moment to ensure data is loaded
            } else {
                alert("Popup blocked! Please allow popups for this site.");
            }
        }


        // Popup message
        function showPopup() {
            loadNewWindow()

            var lastShownDate = localStorage.getItem("popupShownDate");
            var currentDate = new Date().toDateString();

            if (!lastShownDate || lastShownDate !== currentDate) {
                document.getElementById("popupDayLimit").style.display = "block";
                localStorage.setItem("popupShownDate", currentDate);
            }
        }

        function closePopup() {
            document.getElementById("popupDayLimit").style.display = "none";
        }

        // Trigger the popup on page load
        window.onload = showPopup;
    </script>

    <!--Popup message-->
    <div id="popupDayLimit" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background-color: #f5f5f5; padding: 20px; border-radius: 10px; box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.3); z-index: 9999; width: 300px; height: 200px;">
        <h2 style="font-size: 24px; font-weight: bold; color: #333;">Popup Window</h2>
        <p style="font-size: 16px; color: #666;">This is a sample popup window.</p>
        <button onclick="closePopup()" style="background-color: #333; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;">Close</button>
    </div>
</asp:Content>
