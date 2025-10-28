package org.waynewolf.browser;

import android.app.AlertDialog;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import org.mozilla.geckoview.GeckoRuntime;
import org.mozilla.geckoview.GeckoSession;
import org.mozilla.geckoview.GeckoView;

public class MainActivity extends AppCompatActivity {
    private static final String DEFAULT_URL = "https://duckduckgo.com";
    private GeckoView geckoView;
    private GeckoSession geckoSession;
    private GeckoRuntime geckoRuntime;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Setup toolbar
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle("WayneWolf");
        }

        // Initialize GeckoView
        geckoView = findViewById(R.id.geckoview);

        // Create GeckoSession
        geckoSession = new GeckoSession();

        // Create GeckoRuntime
        geckoRuntime = GeckoRuntime.create(this);

        // Open session
        geckoSession.open(geckoRuntime);

        // Attach session to view
        geckoView.setSession(geckoSession);

        // Load default URL
        geckoSession.loadUri(DEFAULT_URL);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_about) {
            showAboutDialog();
            return true;
        } else if (id == R.id.action_home) {
            geckoSession.loadUri(DEFAULT_URL);
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void showAboutDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("About WayneWolf");
        builder.setMessage(
            "WayneWolf Browser\n\n" +
            "Version: 1.0.0\n\n" +
            "A privacy-focused browser built on GeckoView " +
            "(Mozilla's rendering engine)\n\n" +
            "Package: org.waynewolf.browser\n\n" +
            "Built with Claude Code"
        );
        builder.setPositiveButton("OK", (dialog, which) -> dialog.dismiss());
        builder.show();
    }

    @Override
    protected void onDestroy() {
        geckoSession.close();
        super.onDestroy();
    }
}
