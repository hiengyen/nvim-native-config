# hiengyen.nvim

[🇬🇧 English](#english-version) | [🇻🇳 Tiếng Việt](#phiên-bản-tiếng-việt)

---

## English Version

Welcome to **hiengyen.nvim** - a customized Neovim configuration originally derived from Kickstart.nvim, now refactored to use Neovim `v0.12.1` native packages via `vim.pack`, and themed with Dracula. This setup transforms Neovim into a modern IDE, specially tuned to offer a seamless, intelligent, and rich coding experience.

### 🏗️ Config Architecture

This configuration follows a **Native-first** approach, utilizing the built-in `vim.pack` API (available in Neovim v0.12+) to manage plugins without external managers.

#### Directory Structure
```text
.
├── init.lua               # Entry point: options, keymaps, and module loader
├── nvim-pack-lock.json    # Auto-generated lockfile for plugin versions
├── lua/
│   ├── hiengyen/
│   │   ├── pack.lua       # Centralized plugin definitions and vim.pack logic
│   │   ├── health.lua     # Custom health check definitions
│   │   └── plugins/       # Modular plugin configurations
│   │       ├── appearance.lua
│   │       ├── lsp.lua
│   │       ├── editor.lua
│   │       └── search.lua
│   └── custom/            # Reserved for user-specific overrides
```

#### Key Pillars
- **Native Package Management**: Plugins are installed as git submodules/directories in `pack/bundle/start/`, managed via the `vim.pack` API.
- **Strict Versioning**: A lockfile (`nvim-pack-lock.json`) ensures consistent environments across machines.
- **Modularization**: Configurations are split by concerns (LSP, UI, Search) for maintainability.

### 🚀 Fully Supported Languages

This configuration comes with an out-of-the-box system (LSP + Formatter) seamlessly running in the background for:

- **Python**: Supercharged with `pyright` (Static Type checking) and `ruff` (Lightning-fast Linter & Formatter).
- **C / C++**: `clangd` & `clang-format`.
- **Golang**: `gopls`, `goimports` & `gofmt`.
- **Rust**: `rust_analyzer` & `rustfmt`.
- **DevOps (Ansible, Terraform, YAML)**: `ansiblels`, `terraformls`, `yamlls`, `tflint`, `terraform_fmt` & `yamlfmt`.
- **Bash/Shell**: `bashls` & `shfmt`.
- **Nix**: `nil_ls` & `nixfmt`.
- **Lua**: `lua_ls` & `stylua`.

### 📖 Usage Cheat Sheet

_(Note: The **`<Leader>`** key is customized to the **`Space`** bar)_

#### 1. Fundamental Keybinds & Navigation

- **`<Ctrl> + s`**: Instant file saving (works in Normal, Insert, and Visual modes).
- **`<Ctrl> + h/j/k/l`**: Navigate efficiently between split windows.
- **`<Ctrl> + Click`**: Open a URL/link under the cursor directly in the web browser.
  - _Tip for Command-line/Message Area links_: Hold **`<Shift>`** while clicking to bypass Neovim and let your terminal emulator open the link.
- **`<Esc><Esc>`**: Exit built-in Terminal mode easily.
- **`ps`**: Open native package status (**P**ack **S**tatus).
- **`pu`**: Update native packages (**P**ack **U**pdate).
- **`pc`**: Clean inactive native packages (**P**ack **C**lean).
- **`<Leader> + m`**: Open Mason Package Manager UI.
- **SSH/Docker Clipboard**: Seamlessly copies text to your Host OS clipboard (OSC52) whenever you `y` (yank), bypassing complex X11/xclip issues.

#### 2. Workspace & Window Management

- **`<Leader> + wv`**: Split window vertically ([W]indow [V]ertical).
- **`<Leader> + ws`**: Split window horizontally ([W]indow [S]plit).
- **`<Leader> + wq`** (or **`<Leader> + qq`**): Quit the current window instantly.

#### 3. Blazing Fast Searching (Telescope)

- **`<Leader> + sf`** _(Search Files)_: Fuzzy find any file in your workspace.
- **`<Leader> + sg`** _(Search by Grep)_: Live grep for strings everywhere in the project.
- **`<Leader> + sw`** _(Search Word)_: Search the current word under your cursor.
- **`<Leader> + <Leader>`**: Quick switch between recent buffers.
- **`<Leader> + /`**: Fuzzily search content directly inside the current buffer.

#### 4. File Explorer (Neo-tree)

- **`\` (Backslash)**: Toggle the left-side file tree explorer.
  - _Within tree_: Press `a` to add a file/dir, `d` to delete, `r` to rename.

#### 5. IDE Superpowers & AI Assistant

- **Codeium AI Ghost Text**: Predicts your next lines of code as you type.
  - **`<Alt> + a`**: Accept current AI suggestion.
  - **`<Alt> + ]` / `<Alt> + [`**: Cycle to next/previous AI suggestions.
  - **`<Alt> + x`**: Clear/Dismiss ghost text.
- **Standard Autocomplete**: Use arrow keys or `<Ctrl>+n` / `<Ctrl>+p` to navigate. Press **`Tab`** to accept the suggestion.
- **`grd`** _(Goto Definition)_: Jump directly to the original definition of a function/variable.
- **`grr`** _(Goto References)_: View references of where this is used.
- **`grn`** _(Rename)_: Smartly rename a variable across the entire scope.
- **`gra`** _(Code Action)_: Get LSP assistance to fix issues (e.g. auto-imports, refactors).

#### 6. Auto-Formatting (Conform)

- By default, **saving a file (`<Ctrl> + s`)** automatically formats the code to specific language standards.
- **`<Leader> + f`**: Trigger manual forced formatting at any time.

#### 7. Super Speed Surrounding (Mini.surround)

- **Wrap Word (saiw + <char>)**: Hover over a word and rapidly type **`s` -> `a` -> `i` -> `w` -> `"`** (Surround Add Inner Word Quote).
- **Delete Wrapper (sd + <char>)**: Hover over a wrapped word and type **`s` -> `d` -> `"`** (Surround Delete Quote). The quotes disappear instantly.

---

## Phiên Bản Tiếng Việt

Chào mừng bạn đến với **hiengyen.nvim** - một bộ cấu hình Neovim được tinh chỉnh mạnh mẽ, xuất phát từ Kickstart.nvim nhưng đã được refactor sang cơ chế package native của Neovim `v0.12.1` thông qua `vim.pack`, khoác lên mình giao diện Dracula. Cấu hình này được tùy biến để mang lại trải nghiệm code mượt mà, thông minh và đầy đủ tính năng như một IDE hiện đại.

### 🏗️ Kiến Trúc Config

Bộ cấu hình này tuân thủ triết lý **Native-first**, sử dụng trực tiếp API `vim.pack` (có mặt từ Neovim v0.12+) để quản lý các gói mở rộng mà không cần đến các plugin manager bên thứ ba.

#### Cấu Trúc Thư Mục
```text
.
├── init.lua               # Điểm khởi đầu: thiết lập tùy chọn, phím tắt và nạp module
├── nvim-pack-lock.json    # File khóa phiên bản plugin (tự động tạo)
├── lua/
│   ├── hiengyen/
│   │   ├── pack.lua       # Định nghĩa danh sách plugin và logic quản lý vim.pack
│   │   ├── health.lua     # Các kiếm tra sức khỏe (health checks) tùy chỉnh
│   │   └── plugins/       # Cấu hình chi tiết cho từng nhóm plugin
│   │       ├── appearance.lua
│   │       ├── lsp.lua
│   │       ├── editor.lua
│   │       └── search.lua
│   └── custom/            # Thư mục dành riêng cho các tùy biến cá nhân
```

#### Các Đặc Điểm Cốt Lõi
- **Quản lý Package Native**: Plugin được cài đặt vào `pack/bundle/start/`, điều khiển hoàn toàn bằng API `vim.pack`.
- **Nhất quán Phiên bản**: File `nvim-pack-lock.json` đảm bảo môi trường làm việc giống hệt nhau trên mọi máy tính.
- **Tính Modular**: Cấu hình được chia nhỏ theo chức năng (LSP, Giao diện, Tìm kiếm) để dễ dàng bảo trì.

### 🚀 Các Ngôn Ngữ Được Hỗ Trợ Toàn Diện

Bộ cấu hình nhúng sẵn hệ sinh thái phân tích mã nguồn (LSP + Formatter) hoạt động tự động dưới nền:

- **Python**: Mạnh mẽ với `pyright` (Phân tích tĩnh/Gợi ý) và `ruff` (Linter & Formatter siêu tốc).
- **C / C++**: `clangd` & `clang-format`.
- **Golang**: `gopls`, `goimports` & `gofmt`.
- **Rust**: `rust_analyzer` & `rustfmt`.
- **DevOps (Ansible, Terraform, YAML)**: `ansiblels`, `terraformls`, `yamlls`, `tflint`, `terraform_fmt` & `yamlfmt`.
- **Bash/Shell**: `bashls` & `shfmt`.
- **Nix**: `nil_ls` & `nixfmt`.
- **Lua**: `lua_ls` & `stylua`.

### 📖 Sổ Tay Hướng Dẫn Sử Dụng (Cheat Sheet)

_(Lưu ý: Phím **`<Leader>`** mặc định được cấu hình là phím **`Space` (Dấu Cách)**)_

#### 1. Phím tắt Nền tảng & Di chuyển

- **`<Ctrl> + s`**: Lưu file siêu nhanh (Hoạt động ở mọi chế độ).
- **`<Ctrl> + h/j/k/l`**: Nhảy qua lại giữa các cửa sổ chia đôi (Split Window).
- **`<Ctrl> + Click`**: Mở trực tiếp một đường link (URL) tại vùng soạn thảo ra trình duyệt web.
  - _Mẹo mở link thông báo ở đáy màn hình (Command-line)_: Hãy giữ phím **`<Shift>`** rồi click chuột. Hành động này nhường quyền bắt click lại cho ứng dụng Terminal bên ngoài mở link giúp bạn!
- **`<Esc><Esc>`**: Thoát chế độ Terminal.
- **`ps`**: Kiểm tra trạng thái package native (**P**ack **S**tatus).
- **`pu`**: Cập nhật các package native (**P**ack **U**pdate).
- **`pc`**: Dọn dẹp các package không dùng đến (**P**ack **C**lean).
- **`<Leader> + m`**: Mở giao diện cài đặt Linter/Formatter/LSP (Mason).
- **Copy/Paste qua SSH/Docker**: Tự động đồng bộ văn bản vừa `y` (yank) ra Clipboard máy tính cá nhân (qua chuẩn OSC52), không còn lỗi thiếu quyền xclip hay màn hình `:0`.

#### 2. Quản lý Không gian làm việc (Window Splits)

- **`<Leader> + wv`**: Cắt màn hình chia làm hai theo chiều dọc (Window Vertical).
- **`<Leader> + ws`**: Cắt màn hình chia làm hai theo chiều ngang (Window Split).
- **`<Leader> + wq`** hoặc **`<Leader> + qq`**: Đóng cửa sổ hiện tại cực nhanh.

#### 3. Tìm kiếm "Thần tốc" (Telescope)

- **`<Leader> + sf`** _(Search Files)_: Tìm file trong dự án.
- **`<Leader> + sg`** _(Search by Grep)_: Tìm kiếm bất kỳ văn bản nào xuyên suốt toàn bộ dự án.
- **`<Leader> + sw`** _(Search Word)_: Tìm từ khoá nơi con trỏ chuột đang chỉ.
- **`<Leader> + <Leader>`**: Chọn nhanh một file đang mở trước đó.
- **`<Leader> + /`**: Tìm kiếm nội dung trong file hiện hành.

#### 4. Quản lý Thư mục (Neo-tree)

- **`\` (Dấu gạch chéo ngược)**: Mở/Đóng nhanh thanh cây thư mục bên tay trái.
  - _Trong cây thư mục_: Bấm `a` để tạo mục mới, `d` xoá, `r` đổi tên.

#### 5. Trợ lý AI & Sức mạnh IDE

- **Trợ lý Codeium AI (Ghost Text)**: AI đoán trước tương lai và điền sẵn code mờ lấp lánh khi gõ.
  - **`<Alt> + a`**: Chốt nhận toàn bộ gợi ý hiện tại của AI.
  - **`<Alt> + ]` / `<Alt> + [`**: Lật xem phương án gợi ý tiếp theo/trước đó.
  - **`<Alt> + x`**: Xóa/Tắt bỏ gợi ý (tránh vướng mắt).
- **Gợi ý code thông thường**: Dùng mũi tên hoặc `<Ctrl>+n / <Ctrl>+p` để lên xuống menu. **Bấm `Tab`** để điền hoàn thiện chữ.
- **`grd`** _(Goto Definition)_: Nhảy đến vị trí khai báo gốc của biến/hàm.
- **`grr`** _(Goto References)_: Liệt kê nơi biến/hàm được gọi.
- **`grn`** _(Rename)_: Đổi tên biến đồng loạt trên toàn bộ tầm vực.
- **`gra`** _(Code Action)_: Tự động sửa lỗi (VD: tự động import thư viện).

#### 6. Tự động Định dạng (Conform)

- Mặc định **khi bấm Lưu file (`<Ctrl> + s`)**, code sẽ tự động căn lề hoàn hảo dựa trên tiêu chuẩn cốt lõi của từng ngôn ngữ.
- **`<Leader> + f`**: Ép định dạng thủ công bất kỳ lúc nào.

#### 7. Bao bọc chữ nhanh (Mini.surround)

- **Cách Bọc Chữ (saiw + <dấu>)**: Trỏ vào chữ. Gõ nhanh **`s` -> `a` -> `i` -> `w` -> `"`**.
- **Cách Gỡ Bỏ (sd + <dấu>)**: Trỏ vào chữ bị bọc. Gõ nhanh **`s` -> `d` -> `"`**. Lập tức cặp ngoặc sẽ biến mất.
