

(function (globals) {

  var django = globals.django || (globals.django = {});

  
  django.pluralidx = function (n) {
    var v=(n != 1);
    if (typeof(v) == 'boolean') {
      return v ? 1 : 0;
    } else {
      return v;
    }
  };
  

  
  /* gettext library */

  django.catalog = {
    " said": " said", 
    "%(num)s <small>of %(total)s</small>": "%(num)s <small>of %(total)s</small>", 
    "%s characters remaining": "%s characters remaining", 
    "1 user removed from list!": [
      "1 user removed from list!", 
      "%s users removed from list!"
    ], 
    "1 user unbanned successfully!": [
      "1 user unbanned successfully!", 
      "%s users unbanned sucessfully!"
    ], 
    "1m": "1m", 
    "1y": "1y", 
    "3m": "3m", 
    "6m": "6m", 
    "A document with this slug already exists in this locale.": "A document with this slug already exists in this locale.", 
    "A document with this title already exists in this locale.": "A document with this title already exists in this locale.", 
    "Account banned successfully!": "Account banned successfully!", 
    "Account is now being ignored!": "Account is now being ignored!", 
    "Add Rule": "Add Rule", 
    "All": "All", 
    "All Articles: % Localized": "All Articles: % Localized", 
    "An error occured.": "An error occured.", 
    "Answer Votes: % Helpful": "Answer Votes: % Helpful", 
    "Article Votes: % Helpful": "Article Votes: % Helpful", 
    "Bold": "Bold", 
    "Bulleted List": "Bulleted List", 
    "Bulleted list item": "Bulleted list item", 
    "Cancel": "Cancel", 
    "Categories": "Categories", 
    "Choose revisions to compare": "Choose revisions to compare", 
    "Could not upload file. Please try again later.": "Could not upload file. Please try again later.", 
    "Daily": "Daily", 
    "Delete this image": "Delete this image", 
    "Did you mean %s?": "Did you mean %s?", 
    "Enter the URL of the external link": "Enter the URL of the external link", 
    "Enter the name of the article": "Enter the name of the article", 
    "Error deleting image": "Error deleting image", 
    "Error uploading image": "Error uploading image", 
    "External link:": "External link:", 
    "From %(from_input)s to %(to_input)s": "From %(from_input)s to %(to_input)s", 
    "Heading 1": "Heading 1", 
    "Heading 2": "Heading 2", 
    "Heading 3": "Heading 3", 
    "I don't know": "I don't know", 
    "Image Attachment": "Image Attachment", 
    "Images": "Images", 
    "Insert Link": "Insert Link", 
    "Insert Media": "Insert Media", 
    "Insert a link...": "Insert a link...", 
    "Insert media...": "Insert media...", 
    "Invalid image. Please select a valid image file.": "Invalid image. Please select a valid image file.", 
    "Invalid tag entered: %s": "Invalid tag entered: %s", 
    "Italic": "Italic", 
    "Knowledge Base Article": "Knowledge Base Article", 
    "L10n Coverage": "L10n Coverage", 
    "Link target:": "Link target:", 
    "Link text:": "Link text:", 
    "Month beginning %(year)s-%(month)s-%(date)s": "Month beginning %(year)s-%(month)s-%(date)s", 
    "Monthly": "Monthly", 
    "No": "No", 
    "No sections found": "No sections found", 
    "No tags entered.": "No tags entered.", 
    "No users selected!": "No users selected!", 
    "No votes data": "No votes data", 
    "No, ignore": "No, ignore", 
    "Numbered List": "Numbered List", 
    "Numbered list item": "Numbered list item", 
    "Oops, there was an error.": "Oops, there was an error.", 
    "Percent": "Percent", 
    "Please check you are logged in, and try again.": "Please check you are logged in, and try again.", 
    "Please select an image or video to insert.": "Please select an image or video to insert.", 
    "Quote previous message...": "Quote previous message...", 
    "Reply...": "Reply...", 
    "Response preview": "Response preview", 
    "Search Gallery": "Search Gallery", 
    "Search for a user...": "Search for a user...", 
    "Search for common responses": "Search for common responses", 
    "Show content only for specific versions of Firefox or operating systems.": "Show content only for specific versions of Firefox or operating systems.", 
    "Show for...": "Show for...", 
    "Show:": "Show:", 
    "Support article:": "Support article:", 
    "Switch to edit mode": "Switch to edit mode", 
    "Switch to preview mode": "Switch to preview mode", 
    "There was an error generating the preview.": "There was an error generating the preview.", 
    "This account is already banned!": "This account is already banned!", 
    "This account is already being ignored!": "This account is already being ignored!", 
    "Toggle Diff": "Toggle Diff", 
    "Toggle syntax highlighting": "Toggle syntax highlighting", 
    "Top 20 Articles: % Localized": "Top 20 Articles: % Localized", 
    "Upload Media": "Upload Media", 
    "Upload cancelled. Please select an image file.": "Upload cancelled. Please select an image file.", 
    "Uploading \"%s\"...": "Uploading \"%s\"...", 
    "Username not provided.": "Username not provided.", 
    "Videos": "Videos", 
    "Visitors": "Visitors", 
    "Votes": "Votes", 
    "WARNING! Are you sure you want to deactivate this user? This cannot be undone!": "WARNING! Are you sure you want to deactivate this user? This cannot be undone!", 
    "Week beginning %(year)s-%(month)s-%(date)s": "Week beginning %(year)s-%(month)s-%(date)s", 
    "Weekly": "Weekly", 
    "YTD": "YTD", 
    "Yes": "Yes", 
    "You and 1 other replied": "You and 1 other replied", 
    "You are not watching this thread": "You are not watching this thread", 
    "You are watching this thread": "You are watching this thread", 
    "You replied": "You replied", 
    "bold text": "bold text", 
    "cannedresponses": "cannedresponses", 
    "en-US KB": "en-US KB", 
    "italic text": "italic text", 
    "link text": "link text", 
    "media": "media", 
    "non en-US KB": "non en-US KB"
  };

  django.gettext = function (msgid) {
    var value = django.catalog[msgid];
    if (typeof(value) == 'undefined') {
      return msgid;
    } else {
      return (typeof(value) == 'string') ? value : value[0];
    }
  };

  django.ngettext = function (singular, plural, count) {
    var value = django.catalog[singular];
    if (typeof(value) == 'undefined') {
      return (count == 1) ? singular : plural;
    } else {
      return value[django.pluralidx(count)];
    }
  };

  django.gettext_noop = function (msgid) { return msgid; };

  django.pgettext = function (context, msgid) {
    var value = django.gettext(context + '\x04' + msgid);
    if (value.indexOf('\x04') != -1) {
      value = msgid;
    }
    return value;
  };

  django.npgettext = function (context, singular, plural, count) {
    var value = django.ngettext(context + '\x04' + singular, context + '\x04' + plural, count);
    if (value.indexOf('\x04') != -1) {
      value = django.ngettext(singular, plural, count);
    }
    return value;
  };
  

  django.interpolate = function (fmt, obj, named) {
    if (named) {
      return fmt.replace(/%\(\w+\)s/g, function(match){return String(obj[match.slice(2,-2)])});
    } else {
      return fmt.replace(/%s/g, function(match){return String(obj.shift())});
    }
  };


  /* formatting library */

  django.formats = {
    "DATETIME_FORMAT": "N j, Y, P", 
    "DATETIME_INPUT_FORMATS": [
      "%Y-%m-%d %H:%M:%S", 
      "%Y-%m-%d %H:%M:%S.%f", 
      "%Y-%m-%d %H:%M", 
      "%Y-%m-%d", 
      "%m/%d/%Y %H:%M:%S", 
      "%m/%d/%Y %H:%M:%S.%f", 
      "%m/%d/%Y %H:%M", 
      "%m/%d/%Y", 
      "%m/%d/%y %H:%M:%S", 
      "%m/%d/%y %H:%M:%S.%f", 
      "%m/%d/%y %H:%M", 
      "%m/%d/%y"
    ], 
    "DATE_FORMAT": "N j, Y", 
    "DATE_INPUT_FORMATS": [
      "%Y-%m-%d", 
      "%m/%d/%Y", 
      "%m/%d/%y"
    ], 
    "DECIMAL_SEPARATOR": ".", 
    "FIRST_DAY_OF_WEEK": "0", 
    "MONTH_DAY_FORMAT": "F j", 
    "NUMBER_GROUPING": "3", 
    "SHORT_DATETIME_FORMAT": "m/d/Y P", 
    "SHORT_DATE_FORMAT": "m/d/Y", 
    "THOUSAND_SEPARATOR": ",", 
    "TIME_FORMAT": "P", 
    "TIME_INPUT_FORMATS": [
      "%H:%M:%S", 
      "%H:%M:%S.%f", 
      "%H:%M"
    ], 
    "YEAR_MONTH_FORMAT": "F Y"
  };

  django.get_format = function (format_type) {
    var value = django.formats[format_type];
    if (typeof(value) == 'undefined') {
      return format_type;
    } else {
      return value;
    }
  };

  /* add to global namespace */
  globals.pluralidx = django.pluralidx;
  globals.gettext = django.gettext;
  globals.ngettext = django.ngettext;
  globals.gettext_noop = django.gettext_noop;
  globals.pgettext = django.pgettext;
  globals.npgettext = django.npgettext;
  globals.interpolate = django.interpolate;
  globals.get_format = django.get_format;

}(this));

