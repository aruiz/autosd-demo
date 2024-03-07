#include <gtk/gtk.h>


static void
activate (GtkApplication *app,
          gpointer        user_data)
{
    GtkWidget *window = gtk_application_window_new (app);
    gtk_window_set_title (GTK_WINDOW (window), "AutoSD Demo");
    gtk_window_fullscreen (GTK_WINDOW (window));

    GtkWidget *button = gtk_button_new_with_label ("");
    gtk_label_set_markup (
          GTK_LABEL (gtk_button_get_child (GTK_BUTTON (button))),
          "<span font=\"Bold 50.5\">Hello RHIVOS!</span>");

    gtk_window_set_child (GTK_WINDOW (window), button);

    gtk_window_present (GTK_WINDOW (window));
}

int
main (int    argc,
      char **argv)
{
    GtkApplication *app;
    int status;

    app = gtk_application_new ("org.centos.sig.automotive.demo-app", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
    status = g_application_run (G_APPLICATION (app), argc, argv);
    g_object_unref (app);

    return status;
}
