using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Docuflow_projectIT_KPB.Filters
{
    /// <summary>
    /// Penjaga route berbasis session.
    ///
    /// Tanpa argumen: cukup sudah login.
    ///     [SessionAuthorize]
    ///
    /// Dengan peran: hanya peran yang disebut yang boleh masuk.
    ///     [SessionAuthorize("SuperAdmin")]
    ///     [SessionAuthorize("Admin", "SuperAdmin")]
    ///
    /// Pengecekan peran ditaruh di sini, bukan disalin sebagai `if` di dalam
    /// tiap action. Satu action yang lupa memasang `if` diam-diam jadi terbuka;
    /// satu atribut yang lupa dipasang lebih kentara saat dibaca.
    /// </summary>
    public class SessionAuthorizeAttribute : ActionFilterAttribute
    {
        private readonly string[] _peran;

        public SessionAuthorizeAttribute(params string[] peran)
        {
            _peran = peran ?? System.Array.Empty<string>();
        }

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var session = context.HttpContext.Session;
            var username = session.GetString("Username");

            if (string.IsNullOrEmpty(username))
            {
                context.Result = new RedirectToActionResult("Login", "Account", null);
                return;
            }

            if (_peran.Length > 0)
            {
                var role = session.GetString("Role") ?? string.Empty;

                bool boleh = false;
                foreach (var p in _peran)
                {
                    if (string.Equals(role, p, System.StringComparison.Ordinal))
                    {
                        boleh = true;
                        break;
                    }
                }

                if (!boleh)
                {
                    // Dikembalikan ke beranda, bukan ke halaman login: orangnya
                    // sudah sah masuk, hanya tidak berhak atas halaman ini.
                    context.Result = new RedirectToActionResult("Index", "Home", null);
                    return;
                }
            }

            base.OnActionExecuting(context);
        }
    }
}
