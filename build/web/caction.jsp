

<%@page import="com.multi.kk.action.Mail"%>
<%@page import="java.util.UUID"%>
<%@page import="com.multi.kk.action.Dbconnection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Properties"%>
<%@page import="javax.mail.Authenticator" %>
<%@page import="javax.mail.Message" %>
<%@page import="javax.mail.MessagingException" %>
<%@page import="javax.mail.PasswordAuthentication"%>
<%@page import="javax.mail.Session" %>
<%@page import="javax.mail.Transport" %>
<%@page import="javax.mail.internet.AddressException" %>
<%@page import="javax.mail.internet.InternetAddress" %>
<%@page import="javax.mail.internet.MimeMessage" %>
<%@page import="java.util.Date" %>

<%

    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
    String name = "Cloud";
    String user = request.getParameter("user");
    String pass = request.getParameter("pass");
    String skey = request.getParameter("skey");
    System.out.println(user+" "+pass);
    int statuss = Integer.parseInt(request.getParameter("status"));
    System.out.println("The Checking Value is " + statuss);
    String status = "No";
    String status1 = "Yes";
    switch (statuss) {
        case 1:
            try {
                con = Dbconnection.getConnection();
                st = con.createStatement();
                rs = st.executeQuery("select * from reg where Email='" + user + "' AND Pass='" + pass + "' AND  role='Owner'");
                if (rs.next()) {
                    if ((rs.getString("astatus").equals(status))) {
                        response.sendRedirect("index.jsp?amsg=success");
                    } else if (user.equals(rs.getString("Email")) && pass.equals(rs.getString("Pass")) && status1.equals(rs.getString("astatus"))) {
                        String a = rs.getString("Email");
                        System.out.println("The Value is " + a);
                        response.sendRedirect("owner.jsp?msg=success");
                        session.setAttribute("email", rs.getString("Email"));
                        session.setAttribute("name", rs.getString("Name"));
                    }
                } else {
                    response.sendRedirect("index.jsp?omsg=success");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            break;
        case 2:
            try {
                con = Dbconnection.getConnection();
                st = con.createStatement();
                rs = st.executeQuery("select * from reg where Email='" + user + "' AND Pass='" + pass + "' AND  role='User'");
                if (rs.next()) {
                    if ((rs.getString("astatus").equals(status))) {
                        response.sendRedirect("index.jsp?amsg=success");
                    } else if (user.equals(rs.getString("Email")) && pass.equals(rs.getString("Pass")) && status1.equals(rs.getString("astatus"))) {
                        String a = rs.getString("Email");
                        System.out.println("The Value is " + a);
                        response.sendRedirect("user.jsp?msg=success");
                        session.setAttribute("email", rs.getString("Email"));
                        session.setAttribute("uname", rs.getString("Name"));
                    }
                } else {
                    response.sendRedirect("index.jsp?umsg=success");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            break;
        case 3:
            try {
                if (user.equalsIgnoreCase(name) && pass.equalsIgnoreCase(name)) {
                    response.sendRedirect("chome.jsp?msg=success");
                } else {
                    response.sendRedirect("index.jsp?msgg=failed");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            break;
        case 4:
            try {
                if (user.equalsIgnoreCase("Admin") && pass.equalsIgnoreCase("Admin")) {
                    response.sendRedirect("ahome.jsp?msg=success");
                } else {
                    response.sendRedirect("index.jsp?msgg=failed");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            break;
        case 5:
            name = request.getParameter("name");
            String email = request.getParameter("email");
            String dob = request.getParameter("dob");
            String gen = request.getParameter("gen");
            String role = request.getParameter("role");
            String loc = request.getParameter("loc");
            String k = UUID.randomUUID().toString().substring(0, 6);
            String msg = "Name : " + name + "\n\nPassword   : " + k + "\n\nRole   : " + role;
            System.out.println("Reached here");
            final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
            // Get a Properties object
            Properties props = System.getProperties();
            props.setProperty("mail.smtp.host", "smtp.gmail.com");
            props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
            props.setProperty("mail.smtp.socketFactory.fallback", "false");
            props.setProperty("mail.smtp.port", "465");
            props.setProperty("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.auth", "true");
            props.put("mail.debug", "true");
            props.put("mail.store.protocol", "pop3");
            props.put("mail.transport.protocol", "smtp");
            props.put("mail.smtp.ssl.enable", "true");
            //props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            String to = email;
            final String username = "ramanrahul006@gmail.com";
            final String password = "ntcdcqohuwqsypfc";
            try {
                con = Dbconnection.getConnection();
                st = con.createStatement();
                int i = st.executeUpdate("insert into reg (Name, Pass, Email, DOB, Gender, role, Loc, astatus) values ('" + name + "','" + k + "','" + email + "','" + dob + "','" + gen + "','" + role + "','" + loc + "','No')");
                System.out.println(i);
                System.out.println("Reached");
                if (i != 0) {
                    try {
                        System.out.println("Reached1");
                        Session session1 = Session.getDefaultInstance(props,
                                new Authenticator() {
                                    protected PasswordAuthentication getPasswordAuthentication() {
                                        return new PasswordAuthentication(username, password);
                                    }
                                });

                        // -- Create a new message --
                        Message msg1 = new MimeMessage(session1);
                        System.out.println("Reached2");
                        // -- Set the FROM and TO fields --
                        msg1.setFrom(new InternetAddress(username));
                        msg1.setRecipients(Message.RecipientType.TO,
                                InternetAddress.parse(to, false));
                        msg1.setSubject("Credentials");
                        msg1.setText(msg);
                        msg1.setSentDate(new Date());
                        System.out.println("Reached");
                        Transport.send(msg1);
                        System.out.println("Message sent.");
                        response.sendRedirect("ahome.jsp?msg=success");
                    } catch (MessagingException e) {
                        System.out.println("Erreur d'envoi, cause: " + e);
                    }
                } else {
                    response.sendRedirect("index.jsp?msgg=failed");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            break;
        default:
            response.sendRedirect("index.jsp");
    }
%>
