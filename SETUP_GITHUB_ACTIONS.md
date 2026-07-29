# Hướng dẫn dùng OpenManus trên GitHub Actions

Đây là bản OpenManus đã cắt gọn, dùng **GitHub Actions** để chạy agent **theo yêu cầu** (không phải server 24/7).

## 🎯 Cách hoạt động

- **workflow_dispatch**: Mỗi lần bạn chạy workflow, GitHub tạo 1 máy ảo (Ubuntu), cài dependencies, chạy agent, thu kết quả rồi tự huỷ.
- **Miễn phí**: Repo **public** có Actions miễn phí không giới hạn. Repo **private** có ~2000 phút/tháng (chạy 2-3 lần/ngày thì dùng hết).
- **Không có trạng thái**: Mỗi lần chạy là độc lập, không giữ lịch sử hoặc tệp giữa các lần (kết quả tải về artifact, không lưu trên repo).

## 📋 Yêu cầu trước

1. **Tài khoản GitHub** (miễn phí)
2. **API key của LLM** (Claude, OpenRouter, Groq proxy, ...)
3. **GitHub CLI** (tuỳ chọn, để đẩy code nhanh hơn)

## 🚀 Bước 1: Chuẩn bị tài khoản GitHub

### Nếu chưa có tài khoản GitHub:

Vào https://github.com/signup, đăng ký tài khoản miễn phí.

### Nếu đã có:

Không cần làm gì, tiếp tục bước 2.

## 📁 Bước 2: Tạo repository trên GitHub

### Cách A: Dùng GitHub Web UI (dễ nhất)

1. Đăng nhập GitHub
2. Vào https://github.com/new
3. Điền:
   - **Repository name**: `openmanus` (hoặc tên gì tuỳ bạn)
   - **Description**: `OpenManus AI agent runner on GitHub Actions`
   - **Public**: Để công khai (Actions miễn phí không giới hạn)
     - Nếu chọn Private: Sẽ tốn phút chạy (~20-30 phút/lần gọi)
   - **Initialize this repository**: Bỏ (vì ta sẽ push code từ máy)
4. Click **Create repository**

### Cách B: Dùng GitHub CLI (nhanh hơn)

```bash
gh auth login  # Đăng nhập GitHub lần đầu (nếu chưa có)
gh repo create openmanus --public --source=. --remote=origin --push
```

## 🔑 Bước 3: Cấu hình API key (Secrets)

**Quan trọng**: Đừng để API key trong code! Dùng GitHub Secrets để ẩn.

1. Vào repo vừa tạo
2. **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**, thêm 3 secret:

| Tên Secret | Giá trị | Ví dụ |
|---|---|---|
| `LLM_API_KEY` | API key của bạn | `sk-ant-...` (Claude), `sk-or-...` (OpenRouter), v.v |
| `LLM_BASE_URL` | Endpoint LLM | `https://api.anthropic.com/v1/` |
| `LLM_MODEL` | Tên model | `claude-3-7-sonnet-20250219`, `claude-opus`, v.v |

**Ví dụ cụ thể:**

- **Dùng Claude (Anthropic trực tiếp)**:
  ```
  LLM_API_KEY = sk-ant-v0-... (lấy từ https://console.anthropic.com)
  LLM_BASE_URL = https://api.anthropic.com/v1/
  LLM_MODEL = claude-3-7-sonnet-20250219
  ```

- **Dùng OpenRouter (proxy hỗ trợ nhiều model)**:
  ```
  LLM_API_KEY = sk-or-... (lấy từ https://openrouter.ai/keys)
  LLM_BASE_URL = https://openrouter.ai/api/v1/
  LLM_MODEL = anthropic/claude-3.5-sonnet
  ```

- **Dùng Groq (nhanh, LLM open source)**:
  ```
  LLM_API_KEY = gsk_... (lấy từ https://console.groq.com)
  LLM_BASE_URL = https://api.groq.com/openai/v1/
  LLM_MODEL = mixtral-8x7b-32768
  ```

## 📤 Bước 4: Đẩy code lên GitHub

### Cách A: Dùng Git + SSH (an toàn, không cần token)

**Lần đầu**: [Tạo SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-gpg-key) (5 phút)

```bash
# Trên máy của bạn
cd /đường/dẫn/tới/OpenManus-main

git init
git add .
git commit -m "Initial commit: OpenManus cutdown version with GitHub Actions"
git branch -M main
git remote add origin git@github.com:USERNAME/openmanus.git  # Thay USERNAME
git push -u origin main
```

### Cách B: Dùng GitHub CLI (nhanh nhất)

```bash
cd /đường/dẫn/tới/OpenManus-main

gh auth login  # Chọn HTTPS + đăng nhập bằng browser
gh repo create openmanus --public --source=. --remote=origin --push
```

### Cách C: Dùng GitHub Desktop (GUI, dễ nhất cho người mới)

1. Cài [GitHub Desktop](https://desktop.github.com/)
2. File → Clone Repository → chọn folder OpenManus-main
3. Tại "Local Path", chọn repo vừa tạo
4. Trong ứng dụng: Publish branch (tự động push)

## ▶️ Bước 5: Chạy Agent

### Cách A: Từ GitHub Web UI (dễ nhất)

1. Vào repo
2. Tab **Actions**
3. Bên trái: Chọn workflow **"Run OpenManus Agent"**
4. Click **"Run workflow"** (nút xanh bên phải)
5. Nhập prompt vào ô **"Yêu cầu / nhiệm vụ muốn giao cho agent"**
6. Click **"Run workflow"** để chạy

Sau 1-2 phút, bạn sẽ thấy job bắt đầu. Chờ nó xanh ✓.

### Cách B: Từ GitHub CLI (nhanh hơn)

```bash
gh workflow run run-agent.yaml -f prompt="Tìm kiếm giá Bitcoin hiện tại"
```

### Cách C: Từ điện thoại (GitHub Mobile app)

1. Cài **GitHub** app
2. Mở repo → Actions → chạy workflow → nhập prompt

## 📥 Bước 6: Lấy kết quả

1. Vào repo → **Actions**
2. Chọn lần chạy (job) vừa hoàn thành
3. Cuộn xuống → **Artifacts**
4. Download `openmanus-result-XXXXX`
5. Giải nén → mở `run-output.log` để xem log chạy + kết quả
6. Folder `workspace/` chứa các file agent tạo (nếu có)

## 🛠️ Mẹo / Troubleshooting

### ❓ Lần đầu chạy quá lâu (3-5 phút)

**Nguyên nhân**: GitHub đang cài Playwright Chromium (~500MB). Lần sau sẽ nhanh hơn vì `cache: pip` sẽ dùng lại.

**Giải pháp**: Chờ, hoặc nếu không cần browser thì xoá dòng "Install Playwright browser" ở workflow.

### ❌ Lỗi "ModuleNotFoundError" hoặc import lỗi

**Kiểm tra:**
- File `requirements.txt` có đầy đủ tất cả package không?
- Secrets (LLM_API_KEY, v.v) đã điền đầy đủ chưa?

**Fix**: Sửa `requirements.txt`, push lại, chạy lại.

### ❌ Lỗi "API key not found" hoặc 403 Unauthorized

**Nguyên nhân**: 
- Secret không được set đúng
- Secret có lỗi (ký tự thừa, khoảng trắng, v.v)

**Fix**:
1. Vào Settings → Secrets → kiểm tra lại 3 secret
2. Copy-paste sạch (không có khoảng trắng đầu/cuối)
3. Chạy lại workflow

### ❓ Artifact biến mất sau 14 ngày

**Lý do**: GitHub xoá artifact tự động. Nếu cần lưu lâu dài:
- Download luôn sau mỗi lần chạy
- Hoặc đẩy kết quả lên Google Drive / AWS S3 (nâng cao)

### 💰 Sợ tốn phút chạy?

Nếu dùng **repo public**: miễn phí hoàn toàn, không lo.

Nếu **repo private** với free tier: mỗi lần chạy ~20-30 phút. 2000 phút/tháng = ~70 lần/tháng = 2-3 lần/ngày, đủ cho dùng cá nhân.

## 📚 Các ví dụ prompt

```
"Tìm giá Bitcoin hiện tại"

"Hãy tạo một kế hoạch chi tiết để học Python trong 30 ngày"

"Viết một bài blog ngắn về AI" (sẽ dùng Python + LLM để tạo)

"Phân tích danh sách sản phẩm này: [CSV data]" (paste dữ liệu vào)

"Truy cập trang https://example.com và lấy tiêu đề, mô tả chính"
```

## 🔗 Liên kết hữu ích

- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Anthropic API Keys](https://console.anthropic.com/account/keys)
- [OpenRouter](https://openrouter.ai) (proxy LLM)
- [Groq Console](https://console.groq.com) (API key miễn phí)

## ❓ Cần giúp?

Nếu gặp lỗi:
1. Xem log chi tiết ở **Actions** → job → scroll xuống mục logs
2. Kiểm tra **Artifacts** có `run-output.log` không, mở xem chi tiết lỗi
3. Đảm bảo secrets đã set đúng (Settings → Secrets → xem lại tất cả 3 secret)

---

**Bản tóm tắt:**
1. Tạo repo GitHub (public hoặc private)
2. Set 3 secrets: LLM_API_KEY, LLM_BASE_URL, LLM_MODEL
3. Push code lên
4. Vào Actions → chạy workflow → nhập prompt → lấy kết quả ✅
