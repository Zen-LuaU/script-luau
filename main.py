import asyncio
import random
import discord
from discord.ext import commands

# Khởi tạo Intent để bot nhận biết tin nhắn
intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix="!", intents=intents)

# Dictionary lưu trạng thái phép toán đang chờ của từng người chơi {user_id: result}
active_games = {}


@bot.event
async def on_ready():
    print(f"Bot đã đăng nhập thành công dưới tên: {bot.user}")


@bot.command(name="math", help="Bắt đầu trò chơi giải toán")
async def math_game(ctx):
    # Tạo phép tính ngẫu nhiên
    num1 = random.randint(1, 50)
    num2 = random.randint(1, 50)
    operation = random.choice(["+", "-", "*"])

    if operation == "+":
        correct_answer = num1 + num2
    elif operation == "-":
        # Đảm bảo kết quả không âm cho dễ chơi
        if num1 < num2:
            num1, num2 = num2, num1
        correct_answer = num1 - num2
    else:  # Phép nhân
        num1 = random.randint(1, 12)  # Giảm số lại cho phép nhân dễ tính
        num2 = random.randint(1, 12)
        correct_answer = num1 * num2

    # Lưu đáp án của người dùng (chỉ cho phép 1 câu hỏi/người cùng lúc)
    user_id = ctx.author.id
    active_games[user_id] = correct_answer

    await ctx.send(
        f"🎮 **{ctx.author.display_name}**, hãy giải phép tính sau:\n"
        f"👉 **`{num1} {operation} {num2} = ?`**\n"
        f"*(Bạn có 15 giây để trả lời bằng cách nhập số vào chat)*"
    )

    # Hàm kiểm tra tin nhắn phản hồi
    def check(msg):
        return msg.author.id == ctx.author.id and msg.channel.id == ctx.channel.id

    try:
        # Chờ người chơi nhắn tin trong 15 giây
        msg = await bot.wait_for("message", check=check, timeout=15.0)

        # Kiểm tra câu trả lời
        if msg.content.strip().isdigit() or (
            msg.content.strip().startswith("-")
            and msg.content.strip()[1:].isdigit()
        ):
            user_answer = int(msg.content.strip())

            if user_answer == correct_answer:
                await msg.add_reaction("✅")  # Tích xanh nếu đúng
                await ctx.send(
                    f"🎉 Chính xác! **{num1} {operation} {num2} = {correct_answer}**"
                )
            else:
                await msg.add_reaction("❌")  # Tích đỏ nếu sai
                await ctx.send(
                    f"😅 Sai rồi! Đáp án đúng là: **{correct_answer}**"
                )
        else:
            await msg.add_reaction("❌")
            await ctx.send("⚠️ Phản hồi không phải là số hợp lệ!")

    except asyncio.TimeoutError:
        await ctx.send(
            f"⏰ Đã hết thời gian! Đáp án đúng là: **{correct_answer}**"
        )
    finally:
        # Xóa trạng thái câu hỏi của người chơi
        active_games.pop(user_id, None)


# Thay 'YOUR_BOT_TOKEN' bằng Token bot Discord của bạn
bot.run("YOUR_BOT_TOKEN")
import asyncio
import random
import discord
from discord.ext import commands

intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix="!", intents=intents)

active_games = {}

@bot.event
async def on_ready():
    print(f"Bot đã đăng nhập thành công dưới tên: {bot.user}")

@bot.command(name="math", help="Bắt đầu trò chơi giải toán")
async def math_game(ctx):
    num1 = random.randint(1, 50)
    num2 = random.randint(1, 50)
    operation = random.choice(["+", "-", "*"])

    if operation == "+":
        correct_answer = num1 + num2
    elif operation == "-":
        if num1 < num2:
            num1, num2 = num2, num1
        correct_answer = num1 - num2
    else:
        num1 = random.randint(1, 12)
        num2 = random.randint(1, 12)
        correct_answer = num1 * num2

    user_id = ctx.author.id
    active_games[user_id] = correct_answer

    await ctx.send(
        f"🎮 **{ctx.author.display_name}**, hãy giải phép tính sau:\n"
        f"👉 **`{num1} {operation} {num2} = ?`**\n"
        f"*(Bạn có 15 giây để trả lời bằng cách nhập số vào chat)*"
    )

    def check(msg):
        return msg.author.id == ctx.author.id and msg.channel.id == ctx.channel.id

    try:
        msg = await bot.wait_for("message", check=check, timeout=15.0)

        if msg.content.strip().isdigit() or (
            msg.content.strip().startswith("-")
            and msg.content.strip()[1:].isdigit()
        ):
            user_answer = int(msg.content.strip())

            if user_answer == correct_answer:
                await msg.add_reaction("✅")
                await ctx.send(
                    f"🎉 Chính xác! **{num1} {operation} {num2} = {correct_answer}**"
                )
            else:
                await msg.add_reaction("❌")
                await ctx.send(
                    f"😅 Sai rồi! Đáp án đúng là: **{correct_answer}**"
                )
        else:
            await msg.add_reaction("❌")
            await ctx.send("⚠️ Phản hồi không phải là số hợp lệ!")

    except asyncio.TimeoutError:
        await ctx.send(
            f"⏰ Đã hết thời gian! Đáp án đúng me là: **{correct_answer}**"
        )
    finally:
        active_games.pop(user_id, None)

# Token đã được dán vào đây:
TOKEN = "MTU0ODYzMDg1ODY0OTU2NzMyMg.GYTaJl.S5YUNcQletJroay7AxZPi9j4s-z53_T-Ljqy7E"

bot.run(TOKEN)
import asyncio
import random
import discord
from discord.ext import commands

intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix="!", intents=intents)

active_games = {}

@bot.event
async def on_ready():
    print(f"Bot đã đăng nhập thành công dưới tên: {bot.user}")

@bot.command(name="math", help="Bắt đầu trò chơi giải toán")
async def math_game(ctx):
    num1 = random.randint(1, 50)
    num2 = random.randint(1, 50)
    operation = random.choice(["+", "-", "*"])

    if operation == "+":
        correct_answer = num1 + num2
    elif operation == "-":
        if num1 < num2:
            num1, num2 = num2, num1
        correct_answer = num1 - num2
    else:
        num1 = random.randint(1, 12)
        num2 = random.randint(1, 12)
        correct_answer = num1 * num2

    user_id = ctx.author.id
    active_games[user_id] = correct_answer

    await ctx.send(
        f"🎮 **{ctx.author.display_name}**, hãy giải phép tính sau:\n"
        f"👉 **`{num1} {operation} {num2} = ?`**\n"
        f"*(Bạn có 15 giây để trả lời bằng cách nhập số vào chat)*"
    )

    def check(msg):
        return msg.author.id == ctx.author.id and msg.channel.id == ctx.channel.id

    try:
        msg = await bot.wait_for("message", check=check, timeout=15.0)

        if msg.content.strip().isdigit() or (
            msg.content.strip().startswith("-")
            and msg.content.strip()[1:].isdigit()
        ):
            user_answer = int(msg.content.strip())

            if user_answer == correct_answer:
                await msg.add_reaction("✅")
                await ctx.send(
                    f"🎉 Chính xác! **{num1} {operation} {num2} = {correct_answer}**"
                )
            else:
                await msg.add_reaction("❌")
                await ctx.send(
                    f"😅 Sai rồi! Đáp án đúng là: **{correct_answer}**"
                )
        else:
            await msg.add_reaction("❌")
            await ctx.send("⚠️ Phản hồi không phải là số hợp lệ!")

    except asyncio.TimeoutError:
        await ctx.send(
            f"⏰ Đã hết thời gian! Đáp án đúng me là: **{correct_answer}**"
        )
    finally:
        active_games.pop(user_id, None)

# Token đã được dán vào đây:
TOKEN = "MTU0ODYzMDg1ODY0OTU2NzMyMg.GYTaJl.S5YUNcQletJroay7AxZPi9j4s-z53_T-Ljqy7E"

botimport asyncio
import random
import discord
from discord.ext import commands

# Khởi tạo Intent để bot nhận biết tin nhắn
intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix="!", intents=intents)

# Dictionary lưu trạng thái phép toán đang chờ của từng người chơi {user_id: result}
active_games = {}


@bot.event
async def on_ready():
    print(f"Bot đã đăng nhập thành công dưới tên: {bot.user}")


@bot.command(name="math", help="Bắt đầu trò chơi giải toán")
async def math_game(ctx):
    # Tạo phép tính ngẫu nhiên
    num1 = random.randint(1, 50)
    num2 = random.randint(1, 50)
    operation = random.choice(["+", "-", "*"])

    if operation == "+":
        correct_answer = num1 + num2
    elif operation == "-":
        # Đảm bảo kết quả không âm cho dễ chơi
        if num1 < num2:
            num1, num2 = num2, num1
        correct_answer = num1 - num2
    else:  # Phép nhân
        num1 = random.randint(1, 12)  # Giảm số lại cho phép nhân dễ tính
        num2 = random.randint(1, 12)
        correct_answer = num1 * num2

    # Lưu đáp án của người dùng (chỉ cho phép 1 câu hỏi/người cùng lúc)
    user_id = ctx.author.id
    active_games[user_id] = correct_answer

    await ctx.send(
        f"🎮 **{ctx.author.display_name}**, hãy giải phép tính sau:\n"
        f"👉 **`{num1} {operation} {num2} = ?`**\n"
        f"*(Bạn có 15 giây để trả lời bằng cách nhập số vào chat)*"
    )

    # Hàm kiểm tra tin nhắn phản hồi
    def check(msg):
        return msg.author.id == ctx.author.id and msg.channel.id == ctx.channel.id

    try:
        # Chờ người chơi nhắn tin trong 15 giây
        msg = await bot.wait_for("message", check=check, timeout=15.0)

        # Kiểm tra câu trả lời
        if msg.content.strip().isdigit() or (
            msg.content.strip().startswith("-")
            and msg.content.strip()[1:].isdigit()
        ):
            user_answer = int(msg.content.strip())

            if user_answer == correct_answer:
                await msg.add_reaction("✅")  # Tích xanh nếu đúng
                await ctx.send(
                    f"🎉 Chính xác! **{num1} {operation} {num2} = {correct_answer}**"
                )
            else:
                await msg.add_reaction("❌")  # Tích đỏ nếu sai
                await ctx.send(
                    f"😅 Sai rồi! Đáp án đúng là: **{correct_answer}**"
                )
        else:
            await msg.add_reaction("❌")
            await ctx.send("⚠️ Phản hồi không phải là số hợp lệ!")

    except asyncio.TimeoutError:
        await ctx.send(
            f"⏰ Đã hết thời gian! Đáp án đúng là: **{correct_answer}**"
        )
    finally:
        # Xóa trạng thái câu hỏi của người chơi
        active_games.pop(user_id, None)


# Thay 'YOUR_BOT_TOKEN' bằng Token bot Discord của bạn
bot.run(os.getenv("TOKEN"))
