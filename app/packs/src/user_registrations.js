document.addEventListener('DOMContentLoaded', function() {
  const $userRegistrationForm = $("#register-form");
  const $userGroupFields      = $userRegistrationForm.find(".user-group-fields");
  const inputSelector         = 'input[name="user[sign_up_as]"]';
  const newsletterSelector    = 'input[type="checkbox"][name="user[newsletter]"]';
  const $newsletterModal      = $("#sign-up-newsletter-modal");
  const $passwordDisplaySelector = $('input[type="checkbox"][name="user[password_display]"]');
  const $password = $("#registration_user_password");

  const setGroupFieldsVisibility = (value) => {
    if (value === "user") {
      $userGroupFields.hide();
    } else {
      $userGroupFields.show();
    }
  }

  const checkNewsletter = (check) => {
    $userRegistrationForm.find(newsletterSelector).prop("checked", check);
    $newsletterModal.data("continue", true);
    $newsletterModal.foundation("close");
    $userRegistrationForm.submit();
  }

  setGroupFieldsVisibility($userRegistrationForm.find(`${inputSelector}:checked`).val());

  $userRegistrationForm.on("change", inputSelector, (event) => {
    const value = event.target.value;

    setGroupFieldsVisibility(value);
  });

  $userRegistrationForm.on("submit", (event) => {
    const newsletterChecked = $userRegistrationForm.find(newsletterSelector);
    if (!$newsletterModal.data("continue")) {
      if (!newsletterChecked.prop("checked")) {
        event.preventDefault();
        $newsletterModal.foundation("open");
      }
    }
  });

  $passwordDisplaySelector.on("click", (event) => {
    if ($passwordDisplaySelector.prop("checked")){
      $password.get(0).type = 'text';
    }else{
      $password.get(0).type = 'password';
    }
  });

  $newsletterModal.find(".check-newsletter").on("click", (event) => {
    checkNewsletter($(event.target).data("check"));
  });
});
